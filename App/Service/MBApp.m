
#import "MBApp.h"

@implementation MBApp

+ (instancetype)status {
	static MBApp *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
	return sharedInstance;
}


@end
