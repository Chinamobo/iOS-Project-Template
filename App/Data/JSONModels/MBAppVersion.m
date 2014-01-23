
#import "MBAppVersion.h"

@implementation MBAppVersion

+ (JSONKeyMapper*)keyMapper {
    MBAppVersion *this;
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"version": @keypath(this, version),
        @"url": @keypath(this, URI),
        @"release_note": @keypath(this, releaseNote),
        @"force": @keypath(this, isForceUpdate)
    }];
}

@end
