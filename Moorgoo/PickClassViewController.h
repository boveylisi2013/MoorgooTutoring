//
//  PickClassViewController.h
//  Moorgoo
//
//  Created by SI  on 1/1/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickClassViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic) NSString *school;
@property (weak, nonatomic) IBOutlet UITextField *specificClassTextField;
@property (nonatomic, weak) IBOutlet UITextField *pickHelpTextField;
@property (nonatomic, weak) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
