//
//  PushedViewController.m
//  LeakFinder
//
//  Created by Lukas Stührk on 17.09.15.
//  Copyright (c) 2015 Lukas Stührk. All rights reserved.
//

#import "PushedViewController.h"

@interface PushedViewController ()

@property UIViewController *viewController;

@end

@implementation PushedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.viewController = self;
}

- (IBAction)goToRoot:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)goToVC:(id)sender {
    UIViewController *viewController = self.navigationController.childViewControllers.firstObject;
    [self.navigationController popToViewController:viewController animated:YES];
}

@end
