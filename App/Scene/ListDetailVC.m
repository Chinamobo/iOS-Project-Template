//
//  ListDetailVC.m
//  TableList
//
//  Created by Bing Xiong on 7/27/14.
//  Copyright (c) 2014 Mobo. All rights reserved.
//

#import "ListDetailVC.h"

@interface ListDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *detailTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailDate;
@end

@implementation ListDetailVC

-(void) setDetails:(NSDictionary *)details
{
    _details = details;
    if(self.view.window)
    {
        [self upDateUI];
    }
}

-(void) upDateUI
{
    self.title = [NSString stringWithFormat:@"Details of %@", [self.details valueForKeyPath:ORDER_ID]];
    self.detailTitle.text = [self.details valueForKeyPath:TITLE];
    self.detailDate.text = [self.details valueForKeyPath:DATE];
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
    [self upDateUI];
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
