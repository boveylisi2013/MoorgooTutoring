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
    NSMutableArray *classItems;
    NSMutableArray *stableClassItems;
}
@end

@implementation ApplyTutorViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(600, 1000)];
    [scroller setContentOffset: CGPointMake(0, scroller.contentOffset.y)];
    scroller.directionalLockEnabled = YES;
    
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
    
    
    //if(classItems == nil) NSLog(@"classItems is nil");
    //else NSLog(@"in APPLYTUTORVIEWCONTROLLER in viewdidload: %@",classItems);

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
    else  label.text = @"The data has not been loaded yet";
    
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
