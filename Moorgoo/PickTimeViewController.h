//
//  PickTimeViewController.h
//  Moorgoo
//
//  Created by SI  on 1/1/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickTimeViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>
@property(nonatomic) NSString *school;
@property(nonatomic) NSString *course;
@property(nonatomic) NSString *help;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *availableDaysLabel;


@property (nonatomic, weak) IBOutlet UITextField *pickHourTextField;
@property (nonatomic, weak) IBOutlet UIButton *next;

@end
