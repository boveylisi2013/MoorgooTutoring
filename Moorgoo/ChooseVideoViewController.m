//
//  ChooseVideoViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 1/20/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "ChooseVideoViewController.h"
#import "HCYoutubeParser.h"


@interface ChooseVideoViewController ()
{
    NSMutableArray *materialArray;
    NSMutableArray *URLArray;
    NSMutableArray *quarterArray;
}
@end

@implementation ChooseVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videosTableView.delegate = self;
    self.videosTableView.dataSource = self;
    
    materialArray = [[NSMutableArray alloc] init];
    URLArray = [[NSMutableArray alloc] init];
    quarterArray = [[NSMutableArray alloc] init];
    [self getSpecificVideosGetMaterialInto:materialArray getURLInto:URLArray getQuarterInto:quarterArray];
}

// Method to query data from parse
-(void)getSpecificVideosGetMaterialInto:(NSMutableArray *)material getURLInto:(NSMutableArray *)URL getQuarterInto:(NSMutableArray *)quarter
{
    PFQuery *query = [PFQuery queryWithClassName:@"videos"];
    [query whereKey:@"courseName" equalTo:self.courseName];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [material addObjectsFromArray:[objects valueForKey:@"materialCovered"]];
            NSLog(@"%@",material);

            [URL addObjectsFromArray:[objects valueForKey:@"youtubeURL"]];
            [quarter addObjectsFromArray:[objects valueForKey:@"quarter"]];
            
            [self.videosTableView reloadData];
        } else {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}
#pragma mark- classTableView delegete methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [materialArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"videoCell"];

    // configure text for cell
    UILabel *quarterLabel = (UILabel *)[cell viewWithTag:3000];
    UILabel *courseNameLabel = (UILabel *)[cell viewWithTag:4000];
    UILabel *materialLabel = (UILabel *)[cell viewWithTag:5000];
    
    courseNameLabel.text = self.courseName;
    quarterLabel.text = quarterArray[indexPath.row];
    materialLabel.text = materialArray[indexPath.row];
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *URLString = URLArray[indexPath.row];
    
        NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:URLString]];
    
        NSString *quality;
        // Check whether the video has hd720 quality
        if([videos objectForKey:@"hd720"] != nil) quality = @"hd720";
        else if([videos objectForKey:@"medium"] != nil) quality = @"medium";
        else quality = @"small";
    
        MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:quality]]];
        [self presentMoviePlayerViewControllerAnimated:mp];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
