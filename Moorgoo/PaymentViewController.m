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
    NSString *STRIPE_PUBLISHABLE_KEY = @"pk_test_hC4pJSauMzNycdhj0cRfysp6";

    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    PFUser *currentUser = [PFUser currentUser];
    self.emailLabel.text = currentUser.email;
    self.phoneLabel.text = [[currentUser objectForKey:@"phone"] stringValue];
 
    self.classLabel.text = self.course;
    self.dateTimeLabel.text = self.date;
    self.hourLabel.text = self.hour;
    
    amount = [[self.hour substringToIndex:1] integerValue] * 25;
    self.amountLabel.text = [NSString stringWithFormat:@"$%li",(long)amount];
    
    UIImage *creditCardImage = [UIImage imageNamed:@"CreditCardBg.png"];
    UIImageView *creditCardView = [[UIImageView alloc] initWithImage:creditCardImage];
    creditCardView.frame = CGRectMake((self.view.frame.size.width - creditCardImage.size.width)/2.0f, 10.0f, creditCardImage.size.width, creditCardImage.size.height);
    [self.view addSubview:creditCardView];
    
    UILabel *creditCardLabel = [[UILabel alloc] init];
    creditCardLabel.text = NSLocalizedString(@"Enter your credit card information", @"Enter your credit card information");
    creditCardLabel.backgroundColor = [UIColor clearColor];
    creditCardLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
    creditCardLabel.textColor = [UIColor colorWithRed:72.0f/255.0f green:98.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
    creditCardLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7];
    creditCardLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    [creditCardLabel sizeToFit];
    creditCardLabel.frame = CGRectMake(25.0f, 35.0f, creditCardLabel.frame.size.width, creditCardLabel.frame.size.height);
    [self.view addSubview:creditCardLabel];
    
    self.checkoutView = [[STPCheckoutView alloc] initWithFrame:CGRectMake(15.0f, 85.0f, 290.0f, 55.0f) andKey:STRIPE_PUBLISHABLE_KEY];
    self.checkoutView.delegate = self;
    [self.view addSubview:self.checkoutView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Event handlers

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)buy:(id)sender {
//    self.hud.labelText = NSLocalizedString(@"Authorizing...", @"Authorizing...");
//    [self.hud show:YES];
//    
//    [self.checkoutView createToken:^(STPToken *token, NSError *error) {
//        if (error) {
//            [self.hud hide:YES];
//            [self displayError:error];
//        } else {
//            [self charge:token];
//        }
//    }];
//}

- (IBAction)payButtonPressed:(UIButton *)sender
{
    self.hud.labelText = NSLocalizedString(@"Authorizing...", @"Authorizing...");
    [self.hud show:YES];
    
    [self.checkoutView createToken:^(STPToken *token, NSError *error) {
        if (error) {
            [self.hud hide:YES];
            [self displayError:error];
        } else {
            [self charge:token];
        }
    }];
    
    [self performSegueWithIdentifier:@"paymentToFinish" sender:self];
}

#pragma mark - ()

- (void)displayError:(NSError *)error {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}

- (void)charge:(STPToken *)token {
    self.hud.labelText = @"Charging...";
    
    NSDictionary *productInfo = @{
                                  @"itemName": @"xxx",
                                  @"size": @"N/A",
                                  @"cardToken": token.tokenId,
                                  @"name": @"xxx",
                                  @"email": @"boveylisi@gmail.com",
                                  @"address": @"xxx",
                                  @"zip": @"xxx",
                                  @"city_state": @"xxx"
                                  };
    [PFCloud callFunctionInBackground:@"purchaseItem"
                       withParameters:productInfo
                                block:^(id object, NSError *error) {
                                    [self.hud hide:YES];
                                    if (error) {
                                        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                    message:[[error userInfo] objectForKey:@"error"]
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil] show];
                                        
                                    }
                                    else
                                    {
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                        message:@"Thank you for your payment, our customer representive will contact you soon"
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil];
                                        [alert show];
                                    }
                                }];
}

@end
