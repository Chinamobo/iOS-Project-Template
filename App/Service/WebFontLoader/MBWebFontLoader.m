
#import "MBWebFontLoader.h"
#import <CoreText/CoreText.h>

@interface MBWebFontLoader ()
@end

@implementation MBWebFontLoader

// REF: https://developer.apple.com/library/ios/samplecode/DownloadFont/
+ (void)loadFontName:(NSString *)fontName callback:(void (^)(BOOL))fontDescriptorCallback {
    NSParameterAssert(fontName);



    UIFont* aFont = [UIFont fontWithName:fontName size:12.];
    // If the font is already downloaded
	if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        fontDescriptorCallback(YES);
		return;
	}

    void (^completionBlock)(BOOL success) = ^(BOOL success){
        if (fontDescriptorCallback) {
            dispatch_async(dispatch_get_main_queue(), ^ {
                fontDescriptorCallback(success);
            });
        }
    };

    // Create a dictionary with the font's PostScript name.
	NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];

    // Create a new font descriptor reference from the attributes dictionary.
	CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);

    // Create a new font descriptor reference from the attributes dictionary.
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);

    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {

        if (state == kCTFontDescriptorMatchingDidFinish) {
            completionBlock(YES);
        }
        else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            dout_warning(@"Font descriptor matching failed: %@", [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError]);
            completionBlock(NO);
        }
        return (bool)YES;
	});
}

@end
