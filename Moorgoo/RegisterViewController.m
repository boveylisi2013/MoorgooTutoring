//
//  RegisterViewController.m
//  Moorgoo
//
//  Created by SI  on 12/26/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController () {
    UIPickerView *schoolPicker;
    UIPickerView *departmentPicker;
    NSMutableArray *pickerSchoolArray;
    NSMutableArray *pickerDepartmentArray;
}

@end

@implementation RegisterViewController
@synthesize schoolRegisterTextField, departmentRegisterTextField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //keyboard disappear when tapping outside of text field
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [self addSchoolPicker];
    [self addDepartmentPicker];
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)signUpUserPressed:(id)sender
{
    PFUser *user = [PFUser user];
    [user setObject:self.firstRegisterTextField.text forKey:@"firstName"];
    [user setObject:self.lastRegisterTextField.text forKey:@"lastName"];
    user.email = self.emailRegisterTextField.text;
    user.username = self.emailRegisterTextField.text;  //use email as login username
    user.password = self.passwordRegisterTextField.text;
    [user setObject:[NSNumber numberWithInt:[self.phoneRegisterTextField.text intValue]] forKey:@"phone"];
    [user setObject:self.schoolRegisterTextField.text forKey:@"school"];
    [user setObject:self.departmentRegisterTextField.text forKey:@"department"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self performSegueWithIdentifier:@"SignupSuccesful" sender:self];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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
        self.schoolRegisterTextField.text = [NSString stringWithFormat:@"%@", [pickerSchoolArray objectAtIndex:row]];
    else
        self.departmentRegisterTextField.text = [NSString stringWithFormat:@"%@", [pickerDepartmentArray objectAtIndex:row]];
}



//UIpicker view replace keyborad for school
-(void)addSchoolPicker{
    pickerSchoolArray = [[NSMutableArray alloc]init];
    [self getSchools];
    
    schoolPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    schoolPicker.delegate = self;
    schoolPicker.dataSource = self;
    [schoolPicker setShowsSelectionIndicator:YES];
    schoolRegisterTextField.inputView = schoolPicker;
    
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
    schoolRegisterTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    NSLog(@"Done Clicked");
    [schoolRegisterTextField resignFirstResponder];
}

/*
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.frame.size.width, 20)];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
    label.text = [NSString stringWithFormat:@"%@", [pickerArray objectAtIndex:row]];
    return label;
}
*/

-(void)getSchools {
    
    PFQuery *query = [PFQuery queryWithClassName:@"school"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [pickerSchoolArray addObjectsFromArray:[objects valueForKey:@"school"]];
            [pickerSchoolArray insertObject:@"" atIndex:0];
            [pickerSchoolArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSLog(@"Successfully retrieved: %@", pickerSchoolArray);
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
    departmentRegisterTextField.inputView = departmentPicker;
    
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
    departmentRegisterTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked2
{
    NSLog(@"Done Clicked");
    [departmentRegisterTextField resignFirstResponder];
}

-(void)getDepartments {
    
    PFQuery *query = [PFQuery queryWithClassName:@"department"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [pickerDepartmentArray addObjectsFromArray:[objects valueForKey:@"department"]];
            [pickerDepartmentArray insertObject:@"" atIndex:0];
            [pickerDepartmentArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSLog(@"Successfully retrieved: %@", pickerDepartmentArray);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
@end
