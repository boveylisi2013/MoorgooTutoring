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


- (IBAction)RequestButtonPressed:(UIButton *)sender
{
    //verify the existance
    PFUser *currentUser = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"tutor"];
    [query setLimit:1000];
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
                [tutor setObject:availableDay forKey:@"availableDays"];
                [tutor saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded){
                        NSLog(@"Object Uploaded!");
                    }
                    else{
                        NSString *errorString = [[error userInfo] objectForKey:@"error"];
                        NSLog(@"Error: %@", errorString);
                    }
                }];
                
                NSString *errorString = @"Thank you for your application. We will invite you for an interview!";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:errorString
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];

                //////////////////////////send an email to our customer representative
                
                NSDictionary *newTutor = @{
                                           @"email": currentUser.email,
                                           @"phone": [currentUser objectForKey:@"phone"],
                                           @"firstName": [currentUser objectForKey:@"firstName"],
                                           @"lastName": [currentUser objectForKey:@"lastName"],
                                           @"school": [currentUser objectForKey:@"school"]
                                           };
                
                [PFCloud callFunctionInBackground:@"registerTutor"
                                   withParameters:newTutor
                                            block:^(id object, NSError *error) {
                                                if (error)
                                                {
                                                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                                                message:[[error userInfo] objectForKey:@"error"]
                                                                               delegate:nil
                                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                                      otherButtonTitles:nil] show];
                                                }
                                            }];
            }
            else {
                NSString *errorString = @"We have received your application. We will invite you for an interview soon!";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notice"
                                                                message:errorString
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            
            return;
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }];
    
}





@end

