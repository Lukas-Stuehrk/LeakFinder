//
// Created by Lukas Stührk on 16.09.15.
// Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * The ViewControllerObserver is responsible for observing the dismissing of view controllers.
 */
@interface ViewControllerObserver : NSObject

/**
 * Returns the singleton instance of the view controller observer. If the singleton instance has not been created, it
 * is created in the first call of this class method. In the first call of this method, some implementations of methods
 * of UIViewController and UINavigationController are replaced ("swizzled") in order to observe the dismissing of view
 * controllers.
 */
+ (instancetype)sharedInstance;

/** The default timeout (in seconds) until a view controller must be deallocated. Defaults to two seconds. */
@property (nonatomic) NSTimeInterval timeOut;

/**
 * Start observing the given view controller and its view (including) subviews. The view controller and its views then
 * needs to be deallocated in the timeout, otherwise a memory leak warning is triggered.
 *
 * Please note that you usually don't have to call this method yourself. The view controller observer automatically
 * observes all view controllers which are dismissed via standard ways (e.g. dismissViewController:animated: or popping
 * the view controller from a navigation controller).
 */
- (void)startObservingViewController:(UIViewController *)viewController;

@end
