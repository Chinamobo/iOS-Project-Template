/*!
    NSAttributedStringCompatiblity.h

    Copyright © 2014 Chinamobo Co., Ltd.
    https://github.com/Chinamobo/iOS-Project-Template

    Apache License, Version 2.0
    http://www.apache.org/licenses/LICENSE-2.0
 */
#ifndef _MB_NSAttributedStringCompatiblity_
#define _MB_NSAttributedStringCompatiblity_

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0

#define NSFontAttributeName (RF_iOS7Before? UITextAttributeFont : NSFontAttributeName)
#define NSForegroundColorAttributeName (RF_iOS7Before? UITextAttributeTextColor : NSForegroundColorAttributeName)

#endif

#endif