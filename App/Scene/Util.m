//
//  Util.m
//  TableList
//
//  Created by Bing Xiong on 8/2/14.
//  Copyright (c) 2014 Mobo. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSString *) formatDateString:(NSString *) dateStr
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZ"];
    NSDate *date =[dateFormat dateFromString:dateStr];
    date = [Util getNowDateFromatAnDate:date];
    
    //    NSLog(@"dateStr = %@; date = %@, format: %@", dateStr, date, @"YYYY-MM-dd'T'HH:mm:ssZ");
    
    [dateFormat setDateFormat:@"yyyy-MM HH:mm"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate: date];
    
    return currentDateStr;
}

@end
