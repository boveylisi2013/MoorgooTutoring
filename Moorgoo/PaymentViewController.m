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
    PFUser *currentUser;
}



@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *STRIPE_PUBLISHABLE_KEY = @"pk_live_ZscnNFJkGGO0HihDErAQqTVC";

    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    currentUser = [PFUser currentUser];
    self.emailLabel.text = currentUser.email;
    self.phoneLabel.text = [currentUser objectForKey:@"phone"];
 
    self.classLabel.text = self.course;
    self.dateTimeLabel.text = self.date;
    self.hourLabel.text = self.hour;
    
    PFQuery *query = [PFQuery queryWithClassName:@"dictbase"];
    [query whereKey:@"keyColumn" equalTo:@"tutorPrice"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSString *price = [NSString stringWithFormat:@"%@", [[objects valueForKey:@"valueColumn"] objectAtIndex:0]];
            amount = [[self.hour substringToIndex:1] integerValue] * [price intValue];
            self.amountLabel.text = [NSString stringWithFormat:@"$%li",(long)amount];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
    UIImage *creditCardImage = [UIImage imageNamed:@"creditCardBg"];
    UIImageView *creditCardView = [[UIImageView alloc] initWithImage:creditCardImage];
    creditCardView.frame = CGRectMake((self.view.frame.size.width - creditCardImage.size.width)/2.0f, 50.0f, creditCardImage.size.width, creditCardImage.size.height);
    [self.view addSubview:creditCardView];
    
    UILabel *creditCardLabel = [[UILabel alloc] init];
    creditCardLabel.text = NSLocalizedString(@"Enter your credit card information", @"Enter your credit card information");
    creditCardLabel.backgroundColor = [UIColor clearColor];
    creditCardLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f];
    creditCardLabel.textColor = [UIColor colorWithRed:72.0f/255.0f green:98.0f/255.0f blue:111.0f/255.0f alpha:1.0f];
    creditCardLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7];
    creditCardLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    [creditCardLabel sizeToFit];
    creditCardLabel.frame = CGRectMake((self.view.frame.size.width - creditCardImage.size.width)/2.0f+8.0f, 75.0f, creditCardLabel.frame.size.width, creditCardLabel.frame.size.height);
    [self.view addSubview:creditCardLabel];
    
    self.checkoutView = [[STPCheckoutView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - creditCardImage.size.width)/2.0f+8.0f, 125.0f, 290.0f, 55.0f) andKey:STRIPE_PUBLISHABLE_KEY];
    self.checkoutView.delegate = self;
    [self.view addSubview:self.checkoutView];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    [self.view endEditing:NO];
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
                                  @"cardToken": token.tokenId,
                                  @"email": currentUser.email,
                                  @"phone": [currentUser objectForKey:@"phone"],
                                  @"course": self.course,
                                  @"date": self.date,
                                  @"hour": self.hour,
                                  @"price": [NSNumber numberWithInteger:amount],
                                  @"firstName": [currentUser objectForKey:@"firstName"],
                                  @"lastName": [currentUser objectForKey:@"lastName"]
                                  };
    [PFCloud callFunctionInBackground:@"purchase"
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
                                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pay Successfully"
                                                                                        message:@"Thank you for your payment, our customer representive will contact you soon"
                                                                                       delegate:nil
                                                                              cancelButtonTitle:@"OK"
                                                                              otherButtonTitles:nil];
                                        
                                        /////////////////save to transaction
                                        PFObject *transaction = [PFObject objectWithClassName:@"transaction"];
                                        
                                        [transaction setObject:currentUser.objectId forKey:@"user_id"];
                                        [transaction setObject:self.course forKey:@"classname"];
                                        [transaction setObject:self.date forKey:@"date"];
                                        [transaction setObject:@"Paid" forKey:@"status"];
                                        [transaction setObject:[NSNumber numberWithInteger:[self.hour integerValue]] forKey:@"hours"];
                                        [transaction setObject:[NSNumber numberWithInteger:amount] forKey:@"amount"];
                                        [transaction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            if (succeeded){
                                                NSLog(@"Object Uploaded!");
                                            }
                                            else{
                                                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                                                NSLog(@"Error: %@", errorString);
                                            }
                                        }];
                                        
                                        ///////////////////
                                        [PFCloud callFunctionInBackground:@"emailAfterTransaction"
                                                           withParameters:productInfo
                                                                    block:^(id object, NSError *error) {}];
                                                      
                                        /////////////////
                                        [self performSegueWithIdentifier:@"paymentToFinish" sender:self];
                                        [alert show];
                                    }
                                }];
}

@end
