//
//  LoginViewController.m
//  RMenuTableList
//
//  Created by Bing Xiong on 8/24/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (IBAction)touchLoginButton:(UIButton *)sender {
    [MBApp status].isLogin = YES;
    [self performSegueWithIdentifier:@"Login 2 Products" sender:self];
}

- (IBAction)touchLogout:(UIButton *)sender {
    [MBApp status].isLogin = NO;
   [self performSegueWithIdentifier:@"Login 2 1st" sender:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
