//
//  RegisterViewController.h
//  Moorgoo
//
//  Created by SI  on 12/26/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

@interface RegisterViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UITextField *firstRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *lastRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *schoolRegisterTextField;
@property (nonatomic, weak) IBOutlet UITextField *departmentRegisterTextField;

-(IBAction)signUpUserPressed:(id)sender;

@end
