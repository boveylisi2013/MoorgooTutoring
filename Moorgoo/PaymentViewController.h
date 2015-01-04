//
//  PaymentViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 1/3/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface PaymentViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic) NSString *school;
@property(nonatomic) NSString *course;
@property(nonatomic) NSString *help;
@property(nonatomic) NSString *hour;
@property(nonatomic) NSString *date;

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UITextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *expireTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextField;

@property (strong, nonatomic) MBProgressHUD *hud;

@end
