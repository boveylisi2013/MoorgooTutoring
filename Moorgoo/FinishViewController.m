//
//  FinishViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 1/3/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "FinishViewController.h"

@interface FinishViewController ()

@end

@implementation FinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"finishToHome" sender:self];
}


@end
