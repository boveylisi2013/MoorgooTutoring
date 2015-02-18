//
//  VideoViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 1/17/15.
//  Copyright (c) 2015 Moorgoo. All rights reserved.
//

#import "VideoViewController.h"
#import "ChooseVideoViewController.h"

@interface VideoViewController ()
{
    // The array that always holds all the courses
    NSMutableArray *allCoursesArray;
    
    // The array holds courses which will vary based on user input
    NSMutableArray *varyCoursesArray;
    
    // Boolean to check whether it is "no video found" or not for tutor dashboard
    BOOL noVideoFound;
    
    // Boolean to check whether the textfield is empty or not
    BOOL displayAllVideos;
    
}

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the tableView's delegete and datasource to be self
    self.courseTableView.delegate = self;
    self.courseTableView.dataSource = self;
    
    //Query for all the videos from the database and put them into varyCoursesArray
    varyCoursesArray = [[NSMutableArray alloc]init];
    [self getVideos:varyCoursesArray];
    
    //Get another array of classes which will not change when user search for classes
    allCoursesArray = [[NSMutableArray alloc]init];
    [self getVideos:allCoursesArray];
    
    // Add the method to detect change in the searchTextField
    [self.searchTextField addTarget:self
                                    action:@selector(textFieldDidChange:)
                          forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/







// Method to query data from parse
-(void)getVideos:(NSMutableArray *)array
{
    PFQuery *query = [PFQuery queryWithClassName:@"videos"];
    [query setLimit:1000];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray *arrayWithDuplicates = [[NSMutableArray alloc]init];
            [arrayWithDuplicates addObjectsFromArray:[objects valueForKey:@"courseName"]];
            [arrayWithDuplicates insertObject:@"" atIndex:0];
            
            // remove duplicates from array and sort the array
            [array addObjectsFromArray:[[NSSet setWithArray:arrayWithDuplicates] allObjects]];
            [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];


            //NSLog(@"Successfully retrieved: %@", array);
            [self.courseTableView reloadData];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

// the method which will be called when searchTextField is changed
// this method is added as a selector to searchTextField
-(void)textFieldDidChange:(UITextField *)textField
{
    [self.courseTableView setHidden:NO];
    
    // If the textField is empty, display all the videos in the tableView
    if(textField.text.length == 0)
    {
        displayAllVideos = true;
        [self.courseTableView reloadData];

    }
    else
    {
        displayAllVideos = false;
        NSString *inputString = [textField.text uppercaseString];
        NSMutableArray *discardItems = [[NSMutableArray alloc] init];
    
    
        // Filter out videos based on user input
        for (NSString *currentString in varyCoursesArray)
        {
            if(![self string:currentString containsString:inputString])
                [discardItems addObject:currentString];
        }
        [varyCoursesArray removeObjectsInArray:discardItems];
        
        // Add videos back when user delete characters
        for (NSString *currentString in allCoursesArray)
        {
            if([self string:currentString containsString:inputString])
                if(![varyCoursesArray containsObject:currentString])
                    [varyCoursesArray addObject: currentString];
        }
        [self.courseTableView reloadData];
        
    }
    
}

// Helper method which checks whether one string contains another string
-(BOOL)string:(NSString *)string_1 containsString:(NSString *)string_2
{
    return !([string_1 rangeOfString:string_2].location == NSNotFound);
}

// Button pressed method
- (IBAction)searchButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"chooseVideo" sender:self];
}

#pragma mark- classTableView delegete methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([varyCoursesArray count] != 0 && !displayAllVideos)  return [varyCoursesArray count];
    else if(displayAllVideos)                                return [allCoursesArray count];
    else                                                     return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"courseCell"];
    
    // configure text for cell
    UILabel *label = (UILabel *)[cell viewWithTag:2000];
    
    if ([varyCoursesArray count] != 0 && !displayAllVideos)
    {
        noVideoFound = false;
        label.text = varyCoursesArray[indexPath.row];
    }
    else if(displayAllVideos)
    {
        label.text = allCoursesArray[indexPath.row];
//        NSLog(@"cellfor displayall = true");
    }
    else
    {
        noVideoFound = true;
        label.text = @"No videos found";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:2000];
    if(!noVideoFound)
    {
        NSString *chosenString = label.text;
        self.searchTextField.text = chosenString;
    }
    [self.courseTableView setHidden:YES];
    [self.view endEditing:YES];
}

#pragma mark- prepare for segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"chooseVideo"])
    {
        ChooseVideoViewController *controller = (ChooseVideoViewController *)segue.destinationViewController;
        controller.courseName = self.searchTextField.text;
    }
}

//- (IBAction)plauVideo:(UIButton *)sender
//{
//    NSDictionary *videos = [HCYoutubeParser h264videosWithYoutubeURL:[NSURL URLWithString:@"https://www.youtube.com/watch?v=epsPY5FWq7s"]];
//    
//    NSString *quality;
//    // Check whether the video has hd720 quality
//    if([videos objectForKey:@"hd720"] != nil) quality = @"hd720";
//    else if([videos objectForKey:@"medium"] != nil) quality = @"medium";
//    else quality = @"small";
//    
//    MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[videos objectForKey:quality]]];
//    [self presentMoviePlayerViewControllerAnimated:mp];
//    
//}


@end
