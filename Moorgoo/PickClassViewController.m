//
//  PickClassViewController.m
//  Moorgoo
//
//  Created by SI  on 1/1/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "PickClassViewController.h"
#import "PickTimeViewController.h"

@interface PickClassViewController ()
{
    // Arrays for tableView
    NSMutableArray *classItems;
    NSMutableArray *stableClassItems;
    
    UIPickerView *helpPicker;
    NSMutableArray *pickerHelpArray;
}
@end

@implementation PickClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.next.enabled = NO;

    self.tableView.rowHeight = 44;
    
    // Add the method to detect change in the specficClassTextField
    [self.specificClassTextField addTarget:self
                                    action:@selector(textFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Query for all the classes from the database and put them into classItems
    classItems = [[NSMutableArray alloc] init];
    [self getClasses:classItems];
    
    //Get another array of classes which will not change when user search for classes
    stableClassItems = [[NSMutableArray alloc] init];
    [self getClasses:stableClassItems];
    
    //Initially hide the table view
    [self.tableView setHidden:YES];
    
    [self addSchoolPicker];
}

// Method to query data from parse
-(void)getClasses:(NSMutableArray *)array
{
    PFQuery *schoolQuery = [PFUser query];
    [schoolQuery whereKey:@"school" equalTo:self.school];
    [schoolQuery whereKey:@"isTutor" equalTo:[NSNumber numberWithBool:YES]];
    [schoolQuery findObjectsInBackgroundWithBlock:^(NSArray *schoolObjects, NSError *schoolError)
    {
        NSArray *objectIdArray = [schoolObjects valueForKey:@"objectId"];
        if(!schoolError)
        {
            PFQuery *query = [PFQuery queryWithClassName:@"tutor"];
            [query whereKey:@"user_id" containedIn:objectIdArray];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
            {
                if(!error)
                {
                    NSMutableArray *arrayOfArrays = [[NSMutableArray alloc]init];
                    [arrayOfArrays addObjectsFromArray:[objects valueForKey:@"classes"]];
                    NSMutableArray *arrayWithDuplicates = [[NSMutableArray alloc]init];
                
                    for(NSArray *currentArray in arrayOfArrays)
                    {
                        [arrayWithDuplicates addObjectsFromArray:currentArray];
                    }
                    // remove duplicates from array
                    [array addObjectsFromArray:[[NSSet setWithArray:arrayWithDuplicates] allObjects]];
                }
                else
                {
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    NSLog(@"Error: %@", errorString);
                }
            }];
      }
      else
      {
          NSString *errorString = [[schoolError userInfo] objectForKey:@"error"];
          NSLog(@"Error: %@", errorString);
      }
    }];
    

}

// the method which will be called when specificClassTextField is changed
// this method is added as a selector to specficClassTextField
-(void)textFieldDidChange:(UITextField *)textField
{
    //NSLog(@"THE TEXTFIELD IS CHANGED!!");
    if (textField.text.length == 0)
    {
        [self.tableView setHidden:YES];
        self.next.enabled  = NO;
    }
    else
    {
        self.next.enabled  = YES;

        [self.tableView setHidden:NO];
        NSString *inputString = [textField.text uppercaseString];
        NSMutableArray *discardItems = [[NSMutableArray alloc] init];
        
        // Filter out classes based on user input
        for (NSString *currentString in classItems)
        {
            if(![self string:currentString containsString:inputString])
                [discardItems addObject:currentString];
        }
        [classItems removeObjectsInArray:discardItems];
        
        // Add classes back when user delete characters
        for (NSString *currentString in stableClassItems)
        {
            if([self string:currentString containsString:inputString])
                if(![classItems containsObject:currentString])
                    [classItems addObject:currentString];
        }
        [self.tableView reloadData];
    }
    
}

// Helper method which checks whether one string contains another string
-(BOOL)string:(NSString *)string_1 containsString:(NSString *)string_2
{
    return !([string_1 rangeOfString:string_2].location == NSNotFound);
}

#pragma mark - buttonPressed methods
- (IBAction)nextButtonPressed:(UIButton *)sender
{
    if(![classItems containsObject:[self.specificClassTextField.text uppercaseString]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please input & choose the correct class"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        return;
    }
    else
    {
        [self performSegueWithIdentifier:@"classToTime" sender:self];
    }
}


#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"schoolToClass"])
    {
        PickTimeViewController *controller = (PickTimeViewController *)segue.destinationViewController;
        controller.school = self.school;
        controller.course = self.specificClassTextField.text;
    }
}

#pragma mark- classTableView delegete methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"numberOfRowsInSection is called");
    //NSLog(@"classitems size :%lu",(unsigned long)[classItems count]);
    //NSLog(@"in applytutorviewcontroller: %@",classItems);
    
    if ([classItems count] != 0) return [classItems count];
    else    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"whichClassCell"];
    
    // configure text for cell
    UILabel *label = (UILabel *)[cell viewWithTag:2000];
    
    if ([classItems count] != 0)  label.text = classItems[indexPath.row];
    else  label.text = @"No class found";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:2000];
    NSString *chosenString = label.text;
    self.specificClassTextField.text = chosenString;
    [self.tableView setHidden:YES];
    [self.view endEditing:YES];
    //ChecklistItem *item = _items[indexPath.row];
}



#pragma mark - Picker View Data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    if(pickerView == helpPicker)
        return pickerHelpArray.count;
    else
        return pickerHelpArray.count;
}

#pragma mark- Picker View Delegate
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component
{
    if(pickerView == helpPicker)
        return [pickerHelpArray objectAtIndex:row];
    else
        return [pickerHelpArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %ld", (long)row);
    if(pickerView == helpPicker)
        self.pickHelpTextField.text = [NSString stringWithFormat:@"%@", [pickerHelpArray objectAtIndex:row]];
    else
        self.pickHelpTextField.text = [NSString stringWithFormat:@"%@", [pickerHelpArray objectAtIndex:row]];
}


//UIpicker view replace keyborad for pick help
-(void)addSchoolPicker{
    pickerHelpArray = [[NSMutableArray alloc]init];
    [self getHelp];
    
    helpPicker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    helpPicker.delegate = self;
    helpPicker.dataSource = self;
    [helpPicker setShowsSelectionIndicator:YES];
    self.pickHelpTextField.inputView = helpPicker;
    
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
    self.pickHelpTextField.inputAccessoryView = mypickerToolbar;
}

-(void)pickerDoneClicked
{
    //NSLog(@"Done Clicked");
    [self.pickHelpTextField resignFirstResponder];
    if(![self.pickHelpTextField.text isEqual: @""]) {
        self.next.enabled = YES;
    }
    else {
        self.next.enabled = NO;
    }
}

-(void)getHelp {
    
    PFQuery *query = [PFQuery queryWithClassName:@"school"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [pickerHelpArray addObjectsFromArray:[objects valueForKey:@"school"]];
            [pickerHelpArray insertObject:@"" atIndex:0];
            [pickerHelpArray sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            //NSLog(@"Successfully retrieved: %@", pickerDepartmentArray);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

@end
