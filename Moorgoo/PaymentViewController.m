//
//  PaymentViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 1/3/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "PaymentViewController.h"

@interface PaymentViewController ()
{
    NSInteger amount;
}
@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *currentUser = [PFUser currentUser];
    self.emailLabel.text = currentUser.email;
    self.phoneLabel.text = [[currentUser objectForKey:@"phone"] stringValue];
 
    self.classLabel.text = self.course;
    self.dateTimeLabel.text = self.date;
    self.hourLabel.text = self.hour;
    
    amount = [[self.hour substringToIndex:1] integerValue] * 25;
    self.amountLabel.text = [NSString stringWithFormat:@"$%li",(long)amount];
    
    self.cardNumberTextField.delegate = self;
    self.expireTextField.delegate = self;
    self.cvcTextField.delegate = self;
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.cardNumberTextField)
        return [textField.text length] <= 15;
    else if(textField == self.expireTextField)
        return [textField.text length] <= 4;
    else if(textField == self.cvcTextField)
        return [textField.text length] <= 2;
    return false;
}

- (IBAction)submitPressed:(UIButton *)sender
{
    self.hud.labelText = NSLocalizedString(@"Authorizing...", @"Authorizing...");
    [self.hud show:YES];
    
    
}

@end
