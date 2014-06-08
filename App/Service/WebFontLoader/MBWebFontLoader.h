/*!
    MBWebFontLoader
    v 1.0

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import <Foundation/Foundation.h>

/**
 异步字体加载器

 除 iOS 自带的字体外，Apple 提供了额外的字体供开发者使用。当应用请求这些字体时，iOS 系统会自动在后台下载字体并通知应用下载状态。
 
 可用字体列表见 http://support.apple.com/kb/HT5878
 */
@interface MBWebFontLoader : NSObject

/**
 请求指定字体

 @param fontName 需要加载字体的字体名，注意字体名是 PostScript name。比如，列表上的 Songti SC Black，PostScript 名其实是：STSongti-SC-Black。建议用 Mac 上的 Font Book 应用查一下，列表上的字体应该在 Mac 上都有装。
 @param fontDescriptorCompletion 加载结果回调
 */
+ (void)loadFontName:(NSString *)fontName callback:(void (^)(BOOL success))fontDescriptorCompletion;

@end
