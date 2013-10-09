//
//  HeaderDefault.h
//  PKWorld
//
//  Created by 曾 宪华 on 13-9-23.
//  Copyright (c) 2013年 Jack_team. All rights reserved.
//

#ifndef PKWorld_HeaderDefault_h
#define PKWorld_HeaderDefault_h

#ifdef __IPHONE_6_0 // iOS6 and later
#   define UITextAlignmentCenter    NSTextAlignmentCenter
#   define UITextAlignmentLeft      NSTextAlignmentLeft
#   define UITextAlignmentRight     NSTextAlignmentRight
#   define UILineBreakModeTailTruncation     NSLineBreakByTruncatingTail
#   define UILineBreakModeMiddleTruncation   NSLineBreakByTruncatingMiddle
#   define UILineBreakModeCharacterWrap      NSLineBreakByWordWrapping
#endif

#define BUNDLE_IMAGE(_bundleName, _file) [UIImage imageWithContentsOfFile:[[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", _bundleName]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.png", _file, ((int)[[UIScreen mainScreen] scale] - 1) ? @"@2x" : @""]]]

#define BUNDLE_File(_bundleName, _fileName) [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle", _bundleName]] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", _fileName]]

// 获得颜色
#define kGetColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kGlobalBg kGetColor(46, 46, 46)
#define kViewBg kGetColor(221, 221, 221)

// 获得当前屏幕的高度
#define kScreenHeight(orientation) (UIInterfaceOrientationIsLandscape(orientation)?([UIScreen mainScreen].bounds.size.width-20):([UIScreen mainScreen].bounds.size.height-20))

// 获得当前屏幕的宽度
#define kScreenWidth(orientation) (UIInterfaceOrientationIsLandscape(orientation)?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.width)

static BOOL OSVersionIsAtLeastiOS7() {
    return (floor(NSFoundationVersionNumber) >NSFoundationVersionNumber_iOS_6_1);
}
#define isIOS7 (OSVersionIsAtLeastiOS7())

#endif
