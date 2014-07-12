/*!
    MBModalPresentSegue
    v 0.1

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "RFSegue.h"

/**
 弹出新的视图，与 view controller 内建的弹出方式不同之处在于不会隐藏当前视图，新视图不是加在当前视图的 view 中的，而是尽可能加在根视图中，会覆盖导航条
 
 destinationViewController 需要符合 MBModalPresentSegueDelegate 协议
 */
@interface MBModalPresentSegue : RFSegue

@end

/**
 从弹出层 push 到其他视图需使用本 segue，否则可能会导致布局问题，已知的是返回后，隐藏导航栏视图布局不会上移
 */
@interface MBModalPresentPushSegue : UIStoryboardSegue
@end

@protocol MBModalPresentSegueDelegate <NSObject>
@required
- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

@end

@interface MBModalPresentViewController : UIViewController <
    MBModalPresentSegueDelegate
>
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void)setViewHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

@end
