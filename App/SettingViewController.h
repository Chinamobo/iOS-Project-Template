//
//  SettingViewController.h
//  RMenuTableList
//
//  Created by Bing Xiong on 9/3/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/highgui/highgui.hpp>
using namespace cv;

@interface SettingViewController : UIViewController
{

//    CvVideoCamera* videoCamera;
    VideoCapture *_videoCapture;
    Mat _lastFrame;
}

@property (nonatomic) VideoCapture* videoCapture;
//@property (nonatomic, retain) CvVideoCamera* videoCamera;


@end


