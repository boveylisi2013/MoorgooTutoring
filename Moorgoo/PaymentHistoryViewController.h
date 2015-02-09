//
//  PaymentHistoryViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 2/6/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentHistoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *transInfoTableView;


@end
