//
// Created by Lukas Stührk on 16.09.15.
// Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

@import UIKit;

#import <objc/runtime.h>
#import "ViewControllerObserver.h"


@implementation ViewControllerObserver {
    IMP _originalImplementation;
}

void testMethod(UIViewController *self, SEL _cmd, BOOL animated, id completion) {

    ViewControllerObserver *observer = [ViewControllerObserver sharedInstance];

    if (self.presentedViewController) {
        [observer startObservingViewController:self.presentedViewController];
    }

    @autoreleasepool {
        void (* originalImplementation)(id, SEL, BOOL, id) = (void (*)(id, SEL, BOOL, id)) observer->_originalImplementation;
        originalImplementation(self, _cmd, animated, completion);
    }
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ViewControllerObserver *observer;
    dispatch_once(&onceToken, ^{

        Class viewControllerClass = [UIViewController class];
        Method originalMethod = class_getInstanceMethod(viewControllerClass,
                @selector(dismissViewControllerAnimated:completion:));
        IMP originalImplementation = method_setImplementation(originalMethod, (IMP) testMethod);
        NSLog(@"changed");

        observer = [[self alloc] initWithImplementation:originalImplementation];
    });

    return observer;
}

- (instancetype)initWithImplementation:(IMP)originalImplementation {
    if (self = [super init]) {
        _originalImplementation = originalImplementation;
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
