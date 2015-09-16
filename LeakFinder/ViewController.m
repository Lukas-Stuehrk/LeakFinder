//
//  ViewController.m
//  LeakFinder
//
//  Created by Lukas Stührk on 16.09.15.
//  Copyright (c) 2015 Lukas Stührk. All rights reserved.
//


#import "ViewController.h"


void holdReference(id foo) {
    static id blah;
    blah = foo;
}


@interface ViewController ()

@property UIViewController *viewController;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // self.viewController = self;
    holdReference([self.view.subviews firstObject]);
}



- (void)dealloc {
    NSLog(@"dealloc %@", self);
}

- (IBAction)exit:(UIStoryboardSegue *)segue {

}

@end
