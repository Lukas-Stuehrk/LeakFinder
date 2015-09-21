//
// Created by Lukas Stührk on 22.09.15.
// Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LSView : UIView

/// A strong reference to self to create a memory leak.
@property (nonatomic, strong) LSView *strongSelf;

@end
