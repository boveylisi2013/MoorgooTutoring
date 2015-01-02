//
//  ApplyTutorViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 12/29/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "ApplyTutorViewController.h"

@interface ApplyTutorViewController ()
{
    // Arrays for tableView
    NSMutableArray *classItems;
    NSMutableArray *stableClassItems;
    
    // Array to store the classes that
    // the tutor added
    NSMutableArray *addedClasses;
}
@end

@implementation ApplyTutorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    scroller.delegate = self;
    
    // Add the method to detect change in the specficClassTextField
    [self.specificClassTextField addTarget:self
                                         action:@selector(textFieldDidChange:)
                               forControlEvents:UIControlEventEditingChanged];
    
    //Initially hide the table view
    [self.classesTableView setHidden:YES];
    
    //Query for all the classes from the database and put them into classItems
    classItems = [[NSMutableArray alloc] init];
    [self getClasses:classItems];
    
    //Get another array of classes which will not change when user search for classes
    stableClassItems = [[NSMutableArray alloc] init];
    [self getClasses:stableClassItems];
    
    self.classesTableView.delegate = self;
    self.classesTableView.dataSource = self;
    
    addedClasses = [[NSMutableArray alloc]init];
    // Hide the classes and delete buttons unless classes are added
    [self.chosenClass_1 setHidden:YES];
    [self.chosenClass_2 setHidden:YES];
    [self.chosenClass_3 setHidden:YES];
    [self.chosenClass_4 setHidden:YES];
    [self.deleteButton_1 setHidden:YES];
    [self.deleteButton_2 setHidden:YES];
    [self.deleteButton_3 setHidden:YES];
    [self.deleteButton_4 setHidden:YES];

}

// Disable the horizontal scroll
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scroller setContentOffset: CGPointMake(0, scroller.contentOffset.y)];
    scroller.directionalLockEnabled = YES;
}

// Method to query data from parse
-(void)getClasses:(NSMutableArray *)array
{
    PFQuery *query = [PFQuery queryWithClassName:@"classes"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [array addObjectsFromArray:[objects valueForKey:@"classname"]];
            [array insertObject:@"" atIndex:0];
            [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            //NSLog(@"Successfully retrieved: %@", array);
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}


// the method which will be called when specificClassTextField is changed
// this method is added as a selector to specficClassTextField
-(void)textFieldDidChange:(UITextField *)textField
{
    //NSLog(@"THE TEXTFIELD IS CHANGED!!");
    if (textField.text.length == 0) [self.classesTableView setHidden:YES];
    else
    {
        [self.classesTableView setHidden:NO];
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
        [self.classesTableView reloadData];
    }
}

// Helper method which checks whether one string contains another string
-(BOOL)string:(NSString *)string_1 containsString:(NSString *)string_2
{
    return !([string_1 rangeOfString:string_2].location == NSNotFound);
}

#pragma mark- buttonPressed methods
- (IBAction)AddButtonPressed:(UIButton *)sender
{
    // First, check whether the user input the correct class
    NSString *inputString = [self.specificClassTextField.text uppercaseString];
    if(![stableClassItems containsObject:inputString] || inputString.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please input & choose the correct class"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Second, check whether the tutor reach the limit of choosing 4 classes
    if ([addedClasses count] == 4)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You can add at most 4 classes"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [alert show];
            return;
    }
    
    // Third, should not let user add the same class more than once
    if([addedClasses containsObject:inputString])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"You have already added this class"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    [addedClasses addObject:inputString];
    if (self.chosenClass_1.hidden == YES)
    {
        [self.chosenClass_1 setHidden:NO];
        self.chosenClass_1.text = inputString;
        [self.deleteButton_1 setHidden:NO];
    }
    else if(self.chosenClass_2.hidden == YES)
    {
        [self.chosenClass_2 setHidden:NO];
        self.chosenClass_2.text = inputString;
        [self.deleteButton_2 setHidden:NO];
    }
    else if(self.chosenClass_3.hidden == YES)
    {
        [self.chosenClass_3 setHidden:NO];
        self.chosenClass_3.text = inputString;
        [self.deleteButton_3 setHidden:NO];
    }
    else if(self.chosenClass_4.hidden == YES)
    {
        [self.chosenClass_4 setHidden:NO];
        self.chosenClass_4.text = inputString;
        [self.deleteButton_4 setHidden:NO];
    }
}

- (IBAction)deleteButton1Pressed:(UIButton *)sender
{
    [addedClasses removeObject:self.chosenClass_1.text];
    [self.chosenClass_1 setHidden:YES];
    [self.deleteButton_1 setHidden:YES];
}

- (IBAction)deleteButton2Pressed:(UIButton *)sender
{
    [addedClasses removeObject:self.chosenClass_2.text];
    [self.chosenClass_2 setHidden:YES];
    [self.deleteButton_2 setHidden:YES];
}

- (IBAction)deleteButton3Pressed:(UIButton *)sender
{
    [addedClasses removeObject:self.chosenClass_3.text];
    [self.chosenClass_3 setHidden:YES];
    [self.deleteButton_3 setHidden:YES];
}

- (IBAction)deleteButton4Pressed:(UIButton *)sender
{
    [addedClasses removeObject:self.chosenClass_4.text];
    [self.chosenClass_4 setHidden:YES];
    [self.deleteButton_4 setHidden:YES];
}


- (IBAction)submitButtonPressed:(UIButton *)sender
{
    
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classItem"];

    // configure text for cell
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    
    if ([classItems count] != 0)  label.text = classItems[indexPath.row];
    else  label.text = @"No class found";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1000];
    NSString *chosenString = label.text;
    self.specificClassTextField.text = chosenString;
    [self.classesTableView setHidden:YES];
    [self.view endEditing:YES];
    //ChecklistItem *item = _items[indexPath.row];
}

@end
