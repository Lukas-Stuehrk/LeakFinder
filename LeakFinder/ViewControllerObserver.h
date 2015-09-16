//
// Created by Lukas Stührk on 16.09.15.
// Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ViewControllerObserver : NSObject
+ (instancetype)sharedInstance;

/// The default timeout (in seconds) until a view controller must be deallocated.
@property (nonatomic) NSTimeInterval timeOut;

@end
