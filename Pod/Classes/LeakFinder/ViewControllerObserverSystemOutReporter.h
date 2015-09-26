//
// Created by Lukas Stührk on 26.09.15.
//

#import "ViewControllerObserver.h"


/**
 * The default reporter for memory leaks. Logs all found memory leak to the system log ("console").
 */
@interface ViewControllerObserverSystemOutReporter : NSObject <ViewControllerObserverReporter>

@end
