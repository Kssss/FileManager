//
//  CFDeviceManager.h
//  CoinFriend
//
//  Created by Shangen Zhang on 2018/9/18.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface CFScreenSizeManager : NSObject

// 屏幕判断
+ (BOOL)isIphone4S;
+ (BOOL)isIphone5S;
+ (BOOL)isIphone6S;
+ (BOOL)isIphone6P;
+ (BOOL)isIphoneX;
+ (BOOL)isIphoneXR;
+ (BOOL)isIphoneXM;


/**
 顶部安全距离
 */
+ (CGFloat)safeTopAreaHight;

/**
 底部安全距离
 */
+ (CGFloat)safeBottomAreaHight;

/**
 导航栏 高度
 */
+ (CGFloat)tableBarHeight;

/**
 导航栏 高度
 */
+ (CGFloat)navigationBarHeight;
@end

NS_ASSUME_NONNULL_END
