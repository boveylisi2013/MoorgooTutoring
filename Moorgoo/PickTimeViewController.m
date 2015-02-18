//
//  PickTimeViewController.m
//  Moorgoo
//
//  Created by SI  on 1/1/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "PickTimeViewController.h"
#import "PaymentViewController.h"

@interface PickTimeViewController ()
{
    NSArray *weekdays;
    NSMutableArray *availableWeekdays;
    
    UIPickerView *hourPicker;
    NSArray *pickerHourArray;
}

@end

@implementation PickTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    availableWeekdays = [[NSMutableArray alloc] init];
    [self getAvailableDays:availableWeekdays];
    self.next.enabled = NO;
    [self addHourPicker];
    
    
    // make the pickerView show two days after the current date
    [self.datePicker addTarget:self action:@selector(datePickerChanged:) forControlEvents:UIControlEventValueChanged];
    int daysToAdd = 2*60*60*24;
    NSDate *showDate = [[NSDate date] dateByAddingTimeInterval:daysToAdd];
    [self.datePicker setDate:showDate];
    
    // Initialize the weekdays array
    weekdays = @[@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                    message:@"1.You can only schedule a tutor after 2 days from now \n2.Please choose an available weekday. \n3.If the tutor is not available at the time you choose, we will re-schedule or refund"
                                                   delegate:nil
                                          cancelButtonTitle:@"Got it"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)datePickerChanged:(UIDatePicker *)datePicker
{
    self.datePicker = datePicker;
    NSDate *chosenDate = [datePicker date];
    
    // 1. Check whether the chosen date is earlier than two days from current date
    int daysToAdd = 2*60*60*24;
    NSDate *twoDaysFromCurrentDate = [[NSDate date] dateByAddingTimeInterval:daysToAdd];
    if([twoDaysFromCurrentDate compare:chosenDate] == NSOrderedDescending)
    {
        [datePicker setDate:twoDaysFromCurrentDate];
    }

    // 2. Check whether the date is two days away from now
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
}

-(void)getAvailableDays:(NSMutableArray *)array
{
    PFQuery *schoolQuery = [PFUser query];
    [schoolQuery setLimit:1000];
    [schoolQuery whereKey:@"school" equalTo:self.school];
    [schoolQuery whereKey:@"isTutor" equalTo:[NSNumber numberWithBool:YES]];
    [schoolQuery findObjectsInBackgroundWithBlock:^(NSArray *schoolObjects, NSError *schoolError)
     {
         NSArray *objectIdArray = [schoolObjects valueForKey:@"objectId"];
         if(!schoolError)
         {
             PFQuery *query = [PFQuery queryWithClassName:@"tutor"];
             [query setLimit:1000];
             [query whereKey:@"user_id" containedIn:objectIdArray];
             [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
              {
                  if(!error)
                  {
                      NSMutableArray *arrayOfArrays = [[NSMutableArray alloc]init];
                      [arrayOfArrays addObjectsFromArray:[objects valueForKey:@"availableDays"]];
                      NSMutableArray *arrayWithDuplicates = [[NSMutableArray alloc]init];
                      
                      for(NSArray *currentArray in arrayOfArrays)
                      {
                          [arrayWithDuplicates addObjectsFromArray:currentArray];
                      }
                      // remove duplicates from array
                      [array addObjectsFromArray:[[NSSet setWithArray:arrayWithDuplicates] allObjects]];
                      
                      NSString *availableDays = @"";
                      NSString *strongString = @"";
                      
                      // sort the array of weekday strings, from Monday to Sunday
                      NSMutableArray *sortedArray = [self sortWeekDays:array];
                      for(NSString *currentString in sortedArray)
                      {
                          strongString = currentString;
                          strongString = [strongString substringToIndex:3];
                          availableDays = [availableDays stringByAppendingString:strongString];
                          availableDays = [availableDays stringByAppendingString:@"   "];
                      }
                      self.availableDaysLabel.text = availableDays;
                  }
                  else {
                      [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                  }
              }];
         }
         else {
             [[[UIAlertView alloc] initWithTitle:@"Error" message:[schoolError userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
         }
     }];
}

// Helper method to sort the weekdays from Monday to Sunday
-(NSMutableArray *)sortWeekDays:(NSMutableArray *)weekdaysArray
{
    NSMutableArray *sortedArray = [[NSMutableArray alloc] init];
    for(NSString *curr in weekdaysArray)
    {
        if([curr isEqualToString:@"Monday"]) [sortedArray addObject:@"Monday"];
    }
    for(NSString *curr in weekdaysArray)
    {
        if([curr isEqualToString:@"Tuesday"]) [sortedArray addObject:@"Tuesday"];
    }
    for(NSString *curr in weekdaysArray)
    {
        if([curr isEqualToString:@"Wednesday"]) [sortedArray addObject:@"Wednesday"];
    }
    for(NSString *curr in weekdaysArray)
    {
        if([curr isEqualToString:@"Thursday"]) [sortedArray addObject:@"Thursday"];
    }
    for(NSString *curr in weekdaysArray)
    {
        if([curr isEqualToString:@"Friday"]) [sortedArray addObject:@"Friday"];
    }
    for(NSString *curr in weekdaysArray)
    {
        if([curr isEqualToString:@"Saturday"]) [sortedArray addObject:@"Saturday"];
    }
    for(NSString *curr in weekdaysArray)
    {
        if([curr isEqualToString:@"Sunday"]) [sortedArray addObject:@"Sunday"];
    }
    return sortedArray;
}

#pragma mark - buttonPressed methods
- (IBAction)nextButtonPressed:(UIButton *)sender
{
    NSDate *chosenDate = [self.datePicker date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekDayComps = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit) fromDate:chosenDate];
    NSInteger weekday = [weekDayComps weekday];
    NSString *weekdayString = weekdays[weekday - 1];
    
    if(![availableWeekdays containsObject:weekdayString])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"The weekday you chose is not available, please choose another date"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    else
    {
        [self performSegueWithIdentifier:@"timeToPayment" sender:self];
    }
}



#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    if(pickerView == hourPicker)
        return pickerHourArray.count;
    else
        return pickerHourArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    if(pickerView == hourPicker)
        return [pickerHourArray objectAtIndex:row];
    else
        return [pickerHourArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    if(pickerView == hourPicker)
        self.pickHourTextField.text = [NSString stringWithFormat:@"%@", [pickerHourArray objectAtIndex:row]];
    else
        self.pickHourTextField.text = [NSString stringWithFormat:@"%@", [pickerHourArray objectAtIndex:row]];
}

//UIpicker view replace keyborad for pick school
-(void)addHourPicker{
    [self getHours];
    
    hourPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    hourPicker.delegate = self;
    hourPicker.dataSource = self;
    [hourPicker setShowsSelectionIndicator:YES];
    self.pickHourTextField.inputView = hourPicker;
    
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
    self.pickHourTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    //NSLog(@"Done Clicked");
    [self.pickHourTextField resignFirstResponder];
    if(![self.pickHourTextField.text isEqual: @""]) {
        self.next.enabled = YES;
    }
    else {
        self.next.enabled = NO;
    }
}

-(void)getHours {
    pickerHourArray = [[NSMutableArray alloc] init];
    pickerHourArray = @[@"", @"1 Hour", @"2 Hours", @"3 Hours", @"4 Hours"];
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"timeToPayment"])
    {
        PaymentViewController *controller = (PaymentViewController *)segue.destinationViewController;
        controller.school = self.school;
        controller.course = self.course;
        controller.help = self.help;
        
        controller.hour = self.pickHourTextField.text;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd-yyyy HH:mm"];
        NSString *dateString = [dateFormatter stringFromDate:self.datePicker.date];
        controller.date = dateString;
    }
    
}


@end
