//
//  ViewController.h
//  Moorgoo
//
//  Created by SI  on 12/25/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

@interface LoginViewController : UIViewController 

@property (nonatomic, weak) IBOutlet UITextField *userTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

-(IBAction)logInPressed:(id)sender;

@end

