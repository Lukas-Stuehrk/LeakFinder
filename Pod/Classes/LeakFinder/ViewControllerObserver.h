//
// Created by Lukas Stührk on 16.09.15.
// Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * The reporter is called by the the view controller observer when the observer discovered possible memory leaks. It is
 * then responsible for reporting the discovered leaks.
 *
 * @see ViewControllerObserverSystemOutReporter The default implementation of the logger which logs to the system log.
 */
@protocol ViewControllerObserverReporter <NSObject>

/**
 * Called by the observer if a view controller hasn't been deallocated in the required timeout.
 *
 * @param viewController: The view controller which has not been deallocated.
 */
- (void)reportPossibleViewControllerLeak:(UIViewController *)viewController;

/**
 * Called by the observer if a view hasn't been deallocated in the required timeout.
 *
 * @param view:           The view which has not been deallocated.
 * @param viewController: The description of the view controller which was responsible for the view.
 */
- (void)reportPossibleViewLeak:(UIView *)view viewController:(NSString *)viewController;

@end


/**
 * The ViewControllerObserver is responsible for observing the dismissing of view controllers.
 */
@interface ViewControllerObserver : NSObject

/** The default timeout (in seconds) until a view controller must be deallocated. Defaults to two seconds. */
@property (nonatomic) NSTimeInterval timeOut;

/** The reporter which is used to report a memory leak. By default, this is an instance of the SystemLogReporter. */
@property (nonatomic) id<ViewControllerObserverReporter> reporter;

/**
 * Returns the singleton instance of the view controller observer. If the singleton instance has not been created, it
 * is created in the first call of this class method. In the first call of this method, some implementations of methods
 * of UIViewController and UINavigationController are replaced ("swizzled") in order to observe the dismissing of view
 * controllers.
 */
+ (instancetype)sharedInstance;

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
