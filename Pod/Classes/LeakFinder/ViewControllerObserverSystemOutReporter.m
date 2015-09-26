//
// Created by Lukas Stührk on 26.09.15.
//

#import "ViewControllerObserverSystemOutReporter.h"


@implementation ViewControllerObserverSystemOutReporter

- (void)reportPossibleViewControllerLeak:(UIViewController *)viewController {
    NSLog(@"possible memory leak (view controller): %@ (%@)", viewController, [viewController class]);
}

- (void)reportPossibleViewLeak:(UIView *)view viewController:(UIView *)viewController {
    NSLog(@"possible memory leak (view): %@ (%@), view controller: %@", view, [view class], viewController);
}

@end
