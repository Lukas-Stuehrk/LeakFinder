//
//  LSViewController.m
//  LeakFinder
//
//  Created by Lukas Stührk on 09/21/2015.
//  Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

#import "LSViewController.h"
#import "LSView.h"

@interface LSViewController ()

/// A strong reference to self to create a leak.
@property (nonatomic, strong) LSViewController *strongSelf;

@end

@implementation LSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Remove one of the following lines to fix a memory leak.
    self.strongSelf = self;
    ((LSView *)self.view).strongSelf = (LSView *) self.view;
}

- (void)dealloc {
    // Log the dealloc so you can see if the view controller is dealloced.
    NSLog(@"dealloc LSViewController");
}

#pragma mark - Navigation

- (IBAction)exitToFirstViewController:(UIStoryboardSegue *)segue {
    NSLog(@"exit to first view controller called");
}

@end
