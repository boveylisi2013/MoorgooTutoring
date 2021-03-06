//
//  ApplyTutorViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 12/29/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyTutorViewControllerDelegate <NSObject>

@end


@interface ApplyTutorViewController : UIViewController <UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIScrollView *scroller;
    
}
@property (weak, nonatomic) IBOutlet UITableView *classesTableView;
@property (weak, nonatomic) IBOutlet UITextField *specificClassTextField;

@property (weak, nonatomic) IBOutlet UILabel *chosenClass_1;
@property (weak, nonatomic) IBOutlet UILabel *chosenClass_2;
@property (weak, nonatomic) IBOutlet UILabel *chosenClass_3;
@property (weak, nonatomic) IBOutlet UILabel *chosenClass_4;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton_1;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton_2;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton_3;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton_4;

@property (weak, nonatomic) IBOutlet UISwitch *mondaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tuesdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *wednesdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *thursdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fridaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *saturdaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *sundaySwitch;

@property (strong,nonatomic) NSMutableArray *addedClasses;
@property (strong,nonatomic) NSMutableArray *availableDays;

@property (strong,nonatomic) NSString *currentUserId;



@property (nonatomic, weak) id <ApplyTutorViewControllerDelegate> delegate;


@end
