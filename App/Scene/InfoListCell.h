//
//  InfoListCell.h
//  TableList
//
//  Created by Bing Xiong on 7/27/14.
//  Copyright (c) 2014 Mobo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *celTitle;
@property (weak, nonatomic) IBOutlet UILabel *cellDate;
@property (weak, nonatomic) IBOutlet UILabel *cellID;
@property (nonatomic) CGFloat cellHeight;

- (void) SetContent:(NSString *) title andDateStr:(NSString *)date andID:(NSString*)ID flag:(BOOL) flag;

@end
