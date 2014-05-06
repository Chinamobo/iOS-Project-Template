//
//  main.m
//  App
//
//  Created by BB9z on 13-9-22.
//  Copyright (c) 2013年 Chinamobo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "NSDateFormatter+RFKit.h"
#import "NSJSONSerialization+RFKit.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        NSString *tt = [[NSDateFormatter GMTFormatter] stringFromDate:[NSDate date]];
        douto(tt);

        NSString *fff = @"有现车\n颜色有黑、白、红\n可优惠2000元";
        douto([NSJSONSerialization stringWithJSONObject:@{@"rr": fff} options:0 error:nil]);



        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
