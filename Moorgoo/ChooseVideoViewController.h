//
//  ChooseVideoViewController.h
//  Moorgoo
//
//  Created by Xueyang Li on 1/20/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface ChooseVideoViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) NSString *courseName;
@property (weak, nonatomic) IBOutlet UITableView *videosTableView;

@end
