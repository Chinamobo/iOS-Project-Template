/*!
    MBAppVersion

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#import "JSONModel.h"

/**
 自定义版本检测接口返回 model
 */
@interface MBAppVersion : JSONModel
/// 版本号
@property (strong, nonatomic) NSString *version;

/// 标识
@property (strong, nonatomic) NSString *URI;

/// 描述
@property (strong, nonatomic) NSString<Optional> *releaseNote;

/// 最低版本
@property (strong, nonatomic) NSString<Optional> *minimalRequiredVersion;
@end
