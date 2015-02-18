//
//  PickSchoolViewController.m
//  Moorgoo
//
//  Created by SI  on 1/1/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "PickSchoolViewController.h"
#import "PickClassViewController.h"

@interface PickSchoolViewController () {
    UIPickerView *schoolPicker;
    NSMutableArray *pickerSchoolArray;
}

@end

@implementation PickSchoolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.next.enabled = NO;
    [self addSchoolPicker];
    
    // Make the backbutton with only the chevron
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    if(pickerView == schoolPicker)
        return pickerSchoolArray.count;
    else
        return pickerSchoolArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    if(pickerView == schoolPicker)
        return [pickerSchoolArray objectAtIndex:row];
    else
        return [pickerSchoolArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if(pickerView == schoolPicker)
        self.pickSchoolTextField.text = [NSString stringWithFormat:@"%@", [pickerSchoolArray objectAtIndex:row]];
    else
        self.pickSchoolTextField.text = [NSString stringWithFormat:@"%@", [pickerSchoolArray objectAtIndex:row]];
}

//UIpicker view replace keyborad for pick school
-(void)addSchoolPicker{
    pickerSchoolArray = [[NSMutableArray alloc]init];
    [self getSchools];
    
    schoolPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    schoolPicker.delegate = self;
    schoolPicker.dataSource = self;
    [schoolPicker setShowsSelectionIndicator:YES];
    self.pickSchoolTextField.inputView = schoolPicker;
    
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
    self.pickSchoolTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    //NSLog(@"Done Clicked");
    [self.pickSchoolTextField resignFirstResponder];
    if(![self.pickSchoolTextField.text isEqual: @""]) {
        self.next.enabled = YES;
    }
    else {
        self.next.enabled = NO;
    }
}

-(void)getSchools {
    
    PFQuery *query = [PFQuery queryWithClassName:@"school"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [pickerSchoolArray addObjectsFromArray:[objects valueForKey:@"school"]];
            [pickerSchoolArray insertObject:@"" atIndex:0];
            [pickerSchoolArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            //NSLog(@"Successfully retrieved: %@", pickerDepartmentArray);
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"schoolToClass"])
    {
        PickClassViewController *controller = (PickClassViewController *)segue.destinationViewController;
        controller.school = self.pickSchoolTextField.text;
    }
}

@end
