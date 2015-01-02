//
//  PickSchoolViewController.h
//  Moorgoo
//
//  Created by SI  on 1/1/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickSchoolViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UITextField *pickSchoolTextField;
@property (nonatomic, weak) IBOutlet UIButton *next;

@end
