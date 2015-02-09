//
//  PaymentHistoryViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 2/6/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "PaymentHistoryViewController.h"

@interface PaymentHistoryViewController ()
{
    NSString *currentUserId;
    
    NSMutableArray *classArray;
    NSMutableArray *hoursArray;
    NSMutableArray *dateAndTimeArray;
    NSMutableArray *statusArray;
    NSMutableArray *amountArray;
}


@end

@implementation PaymentHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.transInfoTableView.delegate = self;
    self.transInfoTableView.dataSource = self;
    
    PFUser *currentUser = [PFUser currentUser];
    currentUserId = currentUser.objectId;
    
    classArray = [[NSMutableArray alloc] init];
    hoursArray = [[NSMutableArray alloc] init];
    dateAndTimeArray = [[NSMutableArray alloc] init];
    statusArray = [[NSMutableArray alloc] init];
    amountArray = [[NSMutableArray alloc] init];
    
    [self getTransacInfoGetClassInto:classArray getHoursInto:hoursArray getDateInto:dateAndTimeArray getStatusInto:statusArray getAmountInto:amountArray];
}

// Method to query data from parse
-(void)getTransacInfoGetClassInto:(NSMutableArray *)class getHoursInto:(NSMutableArray *)hours getDateInto:(NSMutableArray *)dateAndTime
                                                          getStatusInto:(NSMutableArray *)status getAmountInto:(NSMutableArray *)amount
{
    PFQuery *query = [PFQuery queryWithClassName:@"transaction"];
    [query whereKey:@"user_id" equalTo:currentUserId];
    [query setLimit:1000];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [class addObjectsFromArray:[objects valueForKey:@"classname"]];
            [hours addObjectsFromArray:[objects valueForKey:@"hours"]];
            [dateAndTime addObjectsFromArray:[objects valueForKey:@"date"]];
            [status addObjectsFromArray:[objects valueForKey:@"status"]];
            [amount addObjectsFromArray:[objects valueForKey:@"amount"]];                        
            
            [self.transInfoTableView reloadData];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}

#pragma mark- tableView delegete methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [classArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transInfoCell"];
    
    // configure text for cell
    UILabel *classLabel = (UILabel *)[cell viewWithTag:100];
    UILabel *dateAndTimeLabel = (UILabel *)[cell viewWithTag:200];
    UILabel *hoursLabel = (UILabel *)[cell viewWithTag:300];
    UILabel *amountLabel = (UILabel *)[cell viewWithTag:400];
    UILabel *statusLabel = (UILabel *)[cell viewWithTag:500];
    
    classLabel.text = classArray[indexPath.row];
    dateAndTimeLabel.text = dateAndTimeArray[indexPath.row];
    hoursLabel.text = [hoursArray[indexPath.row] stringValue];
    amountLabel.text = [amountArray[indexPath.row] stringValue];
    statusLabel.text = statusArray[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UILabel *label = (UILabel *)[cell viewWithTag:2000];
//    if(!noVideoFound)
//    {
//        NSString *chosenString = label.text;
//        self.searchTextField.text = chosenString;
//    }
//    [self.courseTableView setHidden:YES];
//    [self.view endEditing:YES];
}


@end
