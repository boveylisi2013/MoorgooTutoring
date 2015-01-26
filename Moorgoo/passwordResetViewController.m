//
//  passwordResetViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 1/25/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "passwordResetViewController.h"

@interface passwordResetViewController ()

@end

@implementation passwordResetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendEmailButtonPressed:(UIButton *)sender
{
    NSString *emmailAddress = self.usernameTextField.text;
    [PFUser requestPasswordResetForEmailInBackground:emmailAddress];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                    message:@"An email will be sent to the email address that belongs to your account in a few minutes, please check your email and use the link to reset your password"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
