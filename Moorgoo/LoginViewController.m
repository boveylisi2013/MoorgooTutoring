//
//  ViewController.m
//  Moorgoo
//
//  Created by SI  on 12/25/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    self.userTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

-(IBAction)logInPressed:(id)sender
{
    [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            [self performSegueWithIdentifier:@"LoginSuccesful" sender:self];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.passwordTextField)
    {
        [self.userTextField resignFirstResponder];
    }
    else if (textField == self.userTextField)
    {
        [self.passwordTextField becomeFirstResponder];
    }
    return YES;
}


@end
