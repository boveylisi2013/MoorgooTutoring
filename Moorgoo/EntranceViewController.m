//
//  EntranceViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 12/27/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "EntranceViewController.h"

@interface EntranceViewController ()
//{
//    NSData *gif;
//    UIWebView *webViewBG;
//}


@end

@implementation EntranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signinButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.signinButton.layer.borderWidth = 2.0f;

    self.registerButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.registerButton.layer.borderWidth = 2.0f;
    
    [self.view addSubview:self.signinButton];
    [self.view addSubview:self.registerButton];
    
    /////////////////////////////////////
    PFQuery *query = [PFQuery queryWithClassName:@"dictbase"];
    [query whereKey:@"keyColumn" equalTo:@"currentVersion"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSString *current_version = [NSString stringWithFormat:@"%@", [[objects valueForKey:@"valueColumn"] objectAtIndex:0]];
            
            NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString* local_version = [infoDict objectForKey:@"CFBundleVersion"];
            if(![current_version isEqualToString:local_version]) {
                self.signinButton.hidden = true;
                self.registerButton.hidden = true;
                
                NSString *download = @"In order to continue, please download the new version of Moorgoo App in the Apple Store!";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention"
                                                                message:download
                                                               delegate:self
                                                      cancelButtonTitle:@"Go To Apple Store to update!"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Go To Apple Store"])
    {
        //NSString *iTunesLink = @"https://itunes.apple.com/us/genre/ios/id36?mt=8";
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
