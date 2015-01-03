//
//  StaticTutorViewController.m
//  Moorgoo
//
//  Created by Xueyang Li on 12/31/14.
//  Copyright (c) 2014 Moorgoo. All rights reserved.
//

#import "StaticTutorViewController.h"

@interface StaticTutorViewController ()

@end

@implementation StaticTutorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)RequestButtonPressed:(UIButton *)sender
{
    //verify the existance
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery *query = [PFQuery queryWithClassName:@"tutor"];
    [query whereKey:@"user_id" equalTo:currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            if(objects.count == 0)
            {
                PFObject *tutor = [PFObject objectWithClassName:@"tutor"];
                
                NSMutableArray *classes = [[NSMutableArray alloc] init];

                
                NSMutableArray *availableDay = [[NSMutableArray alloc] init];

                
                [tutor setObject:currentUser.objectId forKey:@"user_id"];
                [tutor setObject:classes forKey:@"classes"];
                [tutor setObject:availableDay forKey:@"availableDay"];
                [tutor saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded){
                        NSLog(@"Object Uploaded!");
                    }
                    else{
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        NSLog(@"Error: %@", errorString);
                    }
                }];
            }
            
            NSString *errorString = @"Thank you for your application. We will contact you soon!";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            
        }
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            NSLog(@"Error: %@", errorString);
        }
    }];
}


@end
