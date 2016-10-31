//
//  UIColor+CJColorCategory.h
//  Antenna
//
//  Created by HHLY on 16/6/12.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CJColorCategory)

/**
 * @brief 根据色值得到颜色
 * @param hex 16进制的色值
 **/
+(UIColor *)colorWithHex:(int)hex;

/**
 * @brief 根据色值得到颜色
 * @param hexString 16进制色值
 **/
+(UIColor *)colorWithHexString:(NSString *)hexString;

/**
 * @brief 根据色值得到颜色
 * @param hexString 16进制色值
 * @param alpha     透明值
 **/

+(UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
