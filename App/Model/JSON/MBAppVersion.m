
#import "MBAppVersion.h"

@implementation MBAppVersion

+ (JSONKeyMapper*)keyMapper {
    MBAppVersion *this;
    return [[JSONKeyMapper alloc] initWithDictionary:@{
        @"url": @keypath(this, URI),
        @"release_note": @keypath(this, releaseNote),
        @"required": @keypath(this, minimalRequiredVersion)
    }];
}

@end
