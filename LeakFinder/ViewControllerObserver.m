//
// Created by Lukas Stührk on 16.09.15.
// Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

@import UIKit;

#import <objc/runtime.h>
#import "ViewControllerObserver.h"


@implementation ViewControllerObserver {
    /** The original implementation of UIViewController's dismissViewController:animated: method */
    IMP _originalDismissViewControllerImplementation;

    /** The original implementation of UINavigationController's popViewController: method */
    IMP _originalPopViewControllerImplementation;

    /** The original implementation of UINavigationController's popToViewController:animated: method */
    IMP _originalPopToViewControllerImplementation;

    /** The original implementation of UINavigationsController's popToRootViewController: method */
    IMP _originalPopToRootViewControllerImplementation;
}

static void swizzledDismissMethod(UIViewController *self, SEL _cmd, BOOL animated, id completion) {

    ViewControllerObserver *observer = [ViewControllerObserver sharedInstance];

    // It's possible that dismissViewController:animated: is called on the presented view controller, not on the
    // view controller which is responsible for presenting the view controller (see also the documentation of
    // UIViewController). Because of that, we have to check if the view controller actually presents another view
    // controller.
    if (self.presentedViewController) {
        [observer startObservingViewController:self.presentedViewController];
    }

    // And call the original implementation, because we still want to dismiss the view.
    @autoreleasepool {
        void (* originalImplementation)(id, SEL, BOOL, id) = (void (*)(id, SEL, BOOL, id)) observer->_originalDismissViewControllerImplementation;
        originalImplementation(self, _cmd, animated, completion);
    }
}

static UIViewController* swizzledPopMethod(UINavigationController *self, SEL _cmd, BOOL animated) {
    ViewControllerObserver *observer = [ViewControllerObserver sharedInstance];

    // Call the original implementation. We still want to dismiss the view.
    @autoreleasepool {
        UIViewController* (* originalImplementation)(id, SEL, BOOL) = (UIViewController* (*)(id, SEL, BOOL)) observer->_originalPopViewControllerImplementation;
        UIViewController *dismissedViewController = originalImplementation(self, _cmd, animated);
        [observer startObservingViewController:dismissedViewController];
        return dismissedViewController;
    }
}

static NSArray* swizzledPopToViewControllerMethod(UINavigationController *self, SEL _cmd, UIViewController *viewController, BOOL animated) {
    ViewControllerObserver *observer = [ViewControllerObserver sharedInstance];

    // Call the original implementation. We still want to dismiss the view.
    @autoreleasepool {
        NSArray* (* originalImplementation)(id, SEL, UIViewController *, BOOL) = (NSArray* (*)(id, SEL, UIViewController *, BOOL)) observer->_originalPopToViewControllerImplementation;
        NSArray *dismissedViewControllers = originalImplementation(self, _cmd, viewController, animated);
        for (UIViewController *dismissed in dismissedViewControllers) {
            [observer startObservingViewController:dismissed];
        }
        return dismissedViewControllers;
    }
}

static NSArray* swizzledPopToRootViewControllerMethod(UINavigationController *self, SEL _cmd, BOOL animated) {
    ViewControllerObserver *observer = [ViewControllerObserver sharedInstance];

    // Call the original implementation. We still want to dismiss the view.
    @autoreleasepool {
        NSArray* (*originalImplementation)(id, SEL, BOOL) = (NSArray* (*)(id, SEL, BOOL)) observer->_originalPopToRootViewControllerImplementation;
        NSArray *dismissedViewControllers = originalImplementation(self, _cmd, animated);
        for (UIViewController *viewController in dismissedViewControllers) {
            [observer startObservingViewController:viewController];
        }
        return dismissedViewControllers;
    }
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ViewControllerObserver *observer;
    dispatch_once(&onceToken, ^{

        observer = [self new];

        // Normal view controller -> modal views, show segues.
        Class viewControllerClass = [UIViewController class];
        Method originalMethod = class_getInstanceMethod(viewControllerClass, @selector(dismissViewControllerAnimated:completion:));
        IMP originalImplementation = method_setImplementation(originalMethod, (IMP) swizzledDismissMethod);
        observer->_originalDismissViewControllerImplementation = originalImplementation;

        // Navigation controller
        Class navigationControllerClass = [UINavigationController class];
        Method originalPopMethod = class_getInstanceMethod(navigationControllerClass, @selector(popViewControllerAnimated:));
        IMP originalPopImplementation = method_setImplementation(originalPopMethod, (IMP) swizzledPopMethod);
        observer->_originalPopViewControllerImplementation = originalPopImplementation;

        Method originalPopToVCMethod = class_getInstanceMethod(navigationControllerClass, @selector(popToViewController:animated:));
        IMP originalPopToVCImplementation = method_setImplementation(originalPopToVCMethod, (IMP)swizzledPopToViewControllerMethod);
        observer->_originalPopToViewControllerImplementation = originalPopToVCImplementation;

        Method originalPopToRootVCMethod = class_getInstanceMethod(navigationControllerClass, @selector(popToRootViewControllerAnimated:));
        IMP originalPopToRootVCImplementation = method_setImplementation(originalPopToRootVCMethod, (IMP)swizzledPopToRootViewControllerMethod);
        observer->_originalPopToRootViewControllerImplementation = originalPopToRootVCImplementation;

    });

    return observer;
}

- (instancetype)init {
    if (self = [super init]) {
        _timeOut = 2;
    }
    return self;
}


- (void)startObservingViewController:(UIViewController *)viewController {
    __weak UIViewController *weakViewController = viewController;
    NSPointerArray *views = [NSPointerArray weakObjectsPointerArray];
    [views addPointer:(__bridge void *)viewController.view];
    for (UIView *view in viewController.view.subviews) {
        [views addPointer:(__bridge void *)view];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (self.timeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakViewController) {
            NSLog(@"Possible memory leak: ViewController %@ (%@)", weakViewController, [weakViewController class]);
        } else {
            for (UIView *view in views.allObjects) {
                NSLog(@"possible memory leak: %@", view);
            }
        }
    });
}

@end
