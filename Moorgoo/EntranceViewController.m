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

//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lajolla" ofType:@"gif"];
//        if(gif == nil)
//            gif = [NSData dataWithContentsOfFile:filePath];
//    
//        if(webViewBG == nil) {
//            webViewBG = [[UIWebView alloc] initWithFrame:self.view.frame];
//            [webViewBG loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
//            webViewBG.userInteractionEnabled = NO;
//            [self.view addSubview:webViewBG];
//        }
//    
//        UIView *filter = [[UIView alloc] initWithFrame:self.view.frame];
//        filter.backgroundColor = [UIColor blackColor];
//        filter.alpha = 0.05;
//        [self.view addSubview:filter];
    
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
    welcomeLabel.text = @"MOORGOO";
    welcomeLabel.textColor = [UIColor whiteColor];
    welcomeLabel.font = [UIFont systemFontOfSize:50];
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:welcomeLabel];
    
    UILabel *welcomeLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 100)];
    welcomeLabel2.text = @"TUTOR";
    welcomeLabel2.textColor = [UIColor whiteColor];
    welcomeLabel2.font = [UIFont systemFontOfSize:50];
    welcomeLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:welcomeLabel2];
    
    self.signinButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.signinButton.layer.borderWidth = 2.0f;

    self.registerButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.registerButton.layer.borderWidth = 2.0f;
    
    [self.view addSubview:self.signinButton];
    [self.view addSubview:self.registerButton];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
