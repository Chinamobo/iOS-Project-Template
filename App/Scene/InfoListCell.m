//
//  InfoListself.m
//  TableList
//
//  Created by Bing Xiong on 7/27/14.
//  Copyright (c) 2014 Mobo. All rights reserved.
//

#import "InfoListCell.h"

@implementation InfoListCell

-(void)setCellHeight:(CGFloat)cellHeight
{
    _cellHeight = cellHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#define MARGIN 20

- (void) SetContent:(NSString *)title andDateStr:(NSString *)date andID:(NSString*)ID flag:(BOOL) flag
{
    int const MAX_LINE = 3;
    [self awakeFromNib];
    self.celTitle.text = title;
    [self.celTitle setNumberOfLines:MAX_LINE];
    [self.celTitle sizeToFit];
    CGRect titleBounds = [self.celTitle bounds];

    self.cellDate.text = date;//[cellInfo valueForKeyPath:DATE];
    self.cellDate.frame = CGRectMake(self.celTitle.frame.origin.x,
                                     self.celTitle.frame.origin.y + self.celTitle.frame.size.height + MARGIN,
                                     0, 0);
    [self.cellDate sizeToFit];
    
    CGRect dateBounds = [self.cellDate bounds];
//    self.cellHeight = 200;//self.celTitle.frame.size.height + self.cellDate.frame.size.height + MARGIN;
    
    int l = [title length]/15;  //15 characters per line
    l = (l>MAX_LINE) ? MAX_LINE: l;
    
    self.cellHeight =  ( l + 1)  * 30 + 50;
    
//    self.cellID.frame = CGRectMake(self.cellID.frame.origin.x,
//                                   self.cellID.frame.origin.y + self.cellHeight/2.0,
//                                   self.cellID.frame.size.width,
//                                   self.cellID.frame.size.height);
    self.cellID.text = ID;
//    [self.cellID sizeToFit];
    
    if(flag == YES)
    {
        NSLog(@"title = %@, lines = %d, self.cellHeight = %f", title, l, self.cellHeight);

        NSLog(@"self = %@, self.celTitle = %@\r\n", self, self.celTitle);
        NSLog(@"self.celTitle.frame = [%f, %f, %f, %f]", self.celTitle.frame.origin.x, self.celTitle.frame.origin.y, self.celTitle.frame.size.height, self.celTitle.frame.size.width);
    }
}


#pragma mark 设置Cell的边框宽度
//- (void)setFrame:(CGRect)frame {
//    frame.origin.x += 10;
//    frame.size.width -= 22 * 10;
//    [super setFrame:frame];
//}

@end
