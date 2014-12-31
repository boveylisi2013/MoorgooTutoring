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


@interface ApplyTutorViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIScrollView *scroller;
    
}
@property (weak, nonatomic) IBOutlet UITableView *classesTableView;
@property (weak, nonatomic) IBOutlet UITextField *specificClassTextField;

@property (nonatomic, weak) id <ApplyTutorViewControllerDelegate> delegate;


@end
