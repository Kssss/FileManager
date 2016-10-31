//
//  UIColor+CJColorCategory.m
//  Antenna
//
//  Created by HHLY on 16/6/12.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "UIColor+CJColorCategory.h"

@implementation UIColor (CJColorCategory)

#pragma mark - 根据色值生成颜色
+(UIColor *)colorWithHex:(int)hex
{
    
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

#pragma mark - 根据16进制色值字符串生成颜色
+(UIColor *)colorWithHexString:(NSString *)hexString
{
    return [self getColorWithHexString:hexString alpha:1.0];
}

#pragma mark - 根据16进制色值字符串和透明度生成颜色
+(UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    return [self getColorWithHexString:hexString alpha:alpha];
}

#pragma mark - 根据16进制色值字符串和透明度生成颜色
+ (UIColor *)getColorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] > 6 || [cString length] <= 1)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString length] > 1?[cString substringWithRange:range]: @"00";
    
    //g
    range.location = 2;
    NSString *gString = [cString length] > 3?[cString substringWithRange:range]: @"00";
    
    //b
    range.location = 4;
    NSString *bString = [cString length] > 5?[cString substringWithRange:range]: @"00";
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

@end
