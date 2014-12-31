//
//  homeViewController.m
//  Moorgoo
//
//  Created by SI  on 12/26/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "homeViewController.h"
#import "ApplyTutorViewController.h"

@interface homeViewController () <ApplyTutorViewControllerDelegate>
{
    NSMutableArray *classes;
}
@end

@implementation homeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // Former Trial: Tried to query the data in homeViewController and passed it into the
    // property(Would make classItems a property in this case) of ApplyTutorViewController
    // in order to get the data done before tha table view load the data, but this way did not work
    // classes = [[NSMutableArray alloc] init];
    // [self getClasses:classes];
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

-(IBAction)logoutPressed:(id)sender
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"LogoutSuccessful" sender:self];
}

// Former Trial: Tried to query the data in homeViewController and passed it into the
// property(Would make classItems a property in this case) of ApplyTutorViewController
// in order to get the data done before tha table view load the data, but this way did not work
//-(void)getClasses:(NSMutableArray *)array
//{
//    PFQuery *query = [PFQuery queryWithClassName:@"classes"];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (!error) {
//            [array addObjectsFromArray:[objects valueForKey:@"classname"]];
//            [array insertObject:@"" atIndex:0];
//            [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//            NSLog(@"Successfully retrieved: %@", array);
//        } else {
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
//            NSLog(@"Error: %@", errorString);
//        }
//    }];
//}
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"BeATutor"])
//    {
//        ApplyTutorViewController *controller = (ApplyTutorViewController *)segue.destinationViewController;
//        controller.delegate = self;
//        //controller.classItems = classes;
//    }
//}

@end
