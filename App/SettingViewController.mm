//
//  SettingViewController.m
//  RMenuTableList
//
//  Created by Bing Xiong on 9/3/14.
//  Copyright (c) 2014 Chinamobo. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImage+OpenCV.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *processBtn;
@property (weak, nonatomic) IBOutlet UIButton *captureBtn;

@end

@implementation SettingViewController

const int kCannyAperture = 5;

- (IBAction)onStartTouched:(UIButton *)sender {
}

- (IBAction)onProcessTouched:(id)sender {
}

- (IBAction)onCaptureTouched:(UIButton *)sender {
   
    if (_videoCapture && _videoCapture->grab())
    {
        (*_videoCapture) >> _lastFrame;
        [self processFrame];
    }
    else
    {
        NSLog(@"Failed to grab frame");
    }
    
}

- (void) initCaputure
{
    // Initialise video capture - only supported on iOS device NOT simulator
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Video capture is not supported in the simulator");
#else
    _videoCapture = new cv::VideoCapture;
    if (!_videoCapture->open(CAP_AVFOUNDATION))
    {
        NSLog(@"Failed to open video camera");
    }
#endif
}


// Perform image processing on the last captured frame and display the results
- (void)processFrame
{
    double t = (double)cv::getTickCount();
    
    cv::Mat grayFrame, output;
    
    // Convert captured frame to grayscale
    cv::cvtColor(_lastFrame, grayFrame, cv::COLOR_RGB2GRAY);
//    cv::seamlessClone(grayFrame, grayFrame, NULL, <#Point p#>, <#OutputArray blend#>, <#int flags#>)
    
    // Perform Canny edge detection using slide values for thresholds
    cv::Canny(grayFrame, output,
              5 * kCannyAperture * kCannyAperture,
              5 * kCannyAperture * kCannyAperture,
              kCannyAperture);
    
    t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency();
    
    // Display result
    self.imageView.image = [UIImage imageWithCVMat:output];
//    self.elapsedTimeLabel.text = [NSString stringWithFormat:@"%.1fms", t];
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
    NSLog(@"viewDidLoad");

    [self initCaputure];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Welcome to OpenCV" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [alert show];
    

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
