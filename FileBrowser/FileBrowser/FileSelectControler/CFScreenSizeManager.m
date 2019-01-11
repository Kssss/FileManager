//
//  CFDeviceManager.m
//  CoinFriend
//
//  Created by Shangen Zhang on 2018/9/18.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "CFScreenSizeManager.h"
#define iPhone4S \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



#define iPhone6s \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(750, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhone6SP \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhoneX \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhoneXMax \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size)) : NO)

#define iPhoneXR \
([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size)) : NO)


typedef NS_ENUM(NSInteger, CFIphoneDevice) {
    CFIphoneDevice_4S = 1,
    CFIphoneDevice_5S,
    CFIphoneDevice_6S,
    CFIphoneDevice_6P,
    CFIphoneDevice_XS,
    CFIphoneDevice_XR,
    CFIphoneDevice_XM
};

static CFIphoneDevice _iphoneDeviceType = 0;

static CGFloat topH = 0;
static CGFloat botH = 0;
static CGFloat navH = 64;
static CGFloat tabH = 49;


@implementation CFScreenSizeManager

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (iPhoneX) {
            _iphoneDeviceType = CFIphoneDevice_XS;
            topH = 24;
            botH = 34;
            navH = 64 + 24;
            tabH = 49 + 34;
        }
        else if (iPhone6SP) {
            _iphoneDeviceType = CFIphoneDevice_6P;
        }
        else if (iPhone6s) {
            _iphoneDeviceType = CFIphoneDevice_6S;
        }
        else if (iPhoneXMax) {
            _iphoneDeviceType = CFIphoneDevice_XM;
            topH = 24;
            botH = 34;
            navH = 64 + 24;
            tabH = 49 + 34;
        }
        else if (iPhoneXR) {
            _iphoneDeviceType = CFIphoneDevice_XR;
            topH = 24;
            botH = 34;
            navH = 64 + 24;
            tabH = 49 + 34;
        }
        else if (iPhone5) {
            _iphoneDeviceType = CFIphoneDevice_5S;
        }
        
    });
}
+ (BOOL)isIphone4S {return _iphoneDeviceType == CFIphoneDevice_4S;}
+ (BOOL)isIphone5S {return _iphoneDeviceType == CFIphoneDevice_5S;}
+ (BOOL)isIphone6S {return _iphoneDeviceType == CFIphoneDevice_6S;}
+ (BOOL)isIphone6P {return _iphoneDeviceType == CFIphoneDevice_6P;}
+ (BOOL)isIphoneX  {return _iphoneDeviceType == CFIphoneDevice_XS;}
+ (BOOL)isIphoneXR {return _iphoneDeviceType == CFIphoneDevice_XR;}
+ (BOOL)isIphoneXM {return _iphoneDeviceType == CFIphoneDevice_XM;}




+ (CGFloat)safeTopAreaHight {
    return topH;
}

+ (CGFloat)safeBottomAreaHight {
    return botH;
}

+ (CGFloat)tableBarHeight {
    return tabH;
}

+ (CGFloat)navigationBarHeight {
    return navH;
}

@end
