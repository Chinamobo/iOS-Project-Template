//
//  MySingleton.h
//  RMenuTest
//
//  Created by Bing Xiong on 8/14/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

@interface MySingleton : NSObject

/**
 * gets singleton object.
 * @return singleton
 */
+ (MySingleton*)sharedInstance;

@end
