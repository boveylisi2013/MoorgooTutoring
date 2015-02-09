//
//  AccountSettingViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 1/23/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "AccountSettingViewController.h"

@interface AccountSettingViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *schoolPicker;
    UIPickerView *departmentPicker;
    NSMutableArray *pickerSchoolArray;
    NSMutableArray *pickerDepartmentArray;
    
    NSString *currentUserFirstName;
    NSString *currentUserLastName;
    NSString *currentUserPhoneNumber;
    NSString *currentUserSchool;
    NSString *currentUserDepartment;
}
@end

@implementation AccountSettingViewController
@synthesize schoolTextField, departmentTextField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFUser *currentUser = [PFUser currentUser];
    
    // Query data for late passing to other view controller
    currentUserFirstName = [currentUser objectForKey:@"firstName"];
    currentUserLastName = [currentUser objectForKey:@"lastName"];
    currentUserPhoneNumber = [currentUser objectForKey:@"phone"];
    currentUserSchool = [currentUser objectForKey:@"school"];
    currentUserDepartment = [currentUser objectForKey:@"department"];
    
    // Prefill the textFields
    self.firstNameTextField.text = currentUserFirstName;
    self.lastNameTextField.text = currentUserLastName;
    self.phoneNumberTextField.text = currentUserPhoneNumber;
    self.schoolTextField.text = currentUserSchool;
    self.departmentTextField.text = currentUserDepartment;
    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self addSchoolPicker];
    [self addDepartmentPicker];
    
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.phoneNumberTextField.delegate = self;
    self.schoolTextField.delegate = self;
    self.departmentTextField.delegate = self;
    
    //self.phoneNumberTextField.keyboardType =  UIKeyboardTypeDecimalPad;
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIpicker view replace keyborad for school
-(void)addSchoolPicker{
    pickerSchoolArray = [[NSMutableArray alloc]init];
    [self getSchools];
    
    schoolPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    schoolPicker.delegate = self;
    schoolPicker.dataSource = self;
    [schoolPicker setShowsSelectionIndicator:YES];
    schoolTextField.inputView = schoolPicker;
    
    // Create done button in UIPickerView
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked)];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    schoolTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    [schoolTextField resignFirstResponder];
}

-(void)getSchools {
    
    PFQuery *query = [PFQuery queryWithClassName:@"school"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [pickerSchoolArray addObjectsFromArray:[objects valueForKey:@"school"]];
            [pickerSchoolArray insertObject:@"" atIndex:0];
            [pickerSchoolArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            //NSLog(@"Successfully retrieved: %@", pickerSchoolArray);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

//UIpicker view replace keyborad for department
-(void)addDepartmentPicker{
    pickerDepartmentArray = [[NSMutableArray alloc]init];
    [self getDepartments];
    
    departmentPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    departmentPicker.delegate = self;
    departmentPicker.dataSource = self;
    [departmentPicker setShowsSelectionIndicator:YES];
    departmentTextField.inputView = departmentPicker;
    
    // Create done button in UIPickerView
    UIToolbar*  mypickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    mypickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [mypickerToolbar sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDoneClicked2)];
    [barItems addObject:doneBtn];
    
    [mypickerToolbar setItems:barItems animated:YES];
    departmentTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked2
{
    //NSLog(@"Done Clicked");
    [departmentTextField resignFirstResponder];
}

-(void)getDepartments {
    
    PFQuery *query = [PFQuery queryWithClassName:@"department"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [pickerDepartmentArray addObjectsFromArray:[objects valueForKey:@"department"]];
            [pickerDepartmentArray insertObject:@"" atIndex:0];
            [pickerDepartmentArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            //NSLog(@"Successfully retrieved: %@", pickerDepartmentArray);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    if(pickerView == schoolPicker)
        return pickerSchoolArray.count;
    else
        return pickerDepartmentArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    if(pickerView == schoolPicker)
        return [pickerSchoolArray objectAtIndex:row];
    else
        return [pickerDepartmentArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %ld", (long)row);
    if(pickerView == schoolPicker)
        self.schoolTextField.text = [NSString stringWithFormat:@"%@", [pickerSchoolArray objectAtIndex:row]];
    else
        self.departmentTextField.text = [NSString stringWithFormat:@"%@", [pickerDepartmentArray objectAtIndex:row]];
}

#pragma mark- buttonPressed methods
- (IBAction)submitButtonPressed:(UIButton *)sender
{
    // The string contains all possible errors
    NSString *errorString = @"";
    
    if (self.firstNameTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your first name\n"];
    }
    if (self.lastNameTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your last name\n"];
    }
    if (self.phoneNumberTextField.text.length == 0) {
        errorString = [errorString stringByAppendingString:@"Please input your phone number\n"];
    }
    if (self.passwordTextField.text.length < 4){
        errorString = [errorString stringByAppendingString:@"Password has to be at least 4 digits long"];
    }

    
    PFUser *user = [PFUser currentUser];
    [user setObject:self.firstNameTextField.text forKey:@"firstName"];
    [user setObject:self.lastNameTextField.text forKey:@"lastName"];
    [user setObject:self.phoneNumberTextField.text forKey:@"phone"];
    [user setObject:self.schoolTextField.text forKey:@"school"];
    [user setObject:self.departmentTextField.text forKey:@"department"];
    user.password = self.passwordTextField.text;
    
    // Check whether the user inputs their information correctly or not
    if ([errorString length] != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [user saveInBackground];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Updating completed"
                                                        message:@"You have successfully updated your account information"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }

}



@end
