//
//  DEMOSecondViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
#import "MBApp.h"
#import "DEMOSecondViewController.h"

@interface DEMOSecondViewController ()

@end

@implementation DEMOSecondViewController

- (IBAction)pushViewController:(id)sender
{
    
    if([MBApp status].isLogin)
    {
        [self performSegueWithIdentifier:@"Second 2 Products" sender:self];
    }
    else
    {
         [self performSegueWithIdentifier:@"Second 2 Login" sender:self];
    }

//    UIViewController *viewController = [[UIViewController alloc] init];
//    viewController.title = @"Pushed Controller";
//    viewController.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:viewController animated:YES];
}

//- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
//{
//    if([identifier isEqualToString:@"Second 2 Products"])
//       {
//           return [MBApp status].isLogin;
//       }
//    
//    return NO;
//}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}

@end
