/**
    自定义版本检测接口返回 model
 */

#import "JSONModel.h"

@interface MBAppVersion : JSONModel
// 版本号
@property (strong, nonatomic) NSString *version;

// 标识
@property (strong, nonatomic) NSString *URI;

// 描述
@property (strong, nonatomic) NSString *releaseNote;
@property (assign, nonatomic) BOOL isForceUpdate;
@end
