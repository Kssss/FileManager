//
//  UIImage+TYHSetting.h
//  TaiYangHua
//
//  Created by Lc on 15/12/25.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJSession,KsFileObjModel;
static const UInt8 IMAGES_TYPES_COUNT = 8;
static const UInt8 TEXT_TYPES_COUNT = 14;
static const UInt8 VIOCEVIDIO_COUNT = 14;
static const UInt8 Application_count = 4;
static const UInt8 AV_COUNT = 12;

//定义图片后缀名
extern NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT];
//定义文本后缀名
extern NSString *TEXT_TYPES[TEXT_TYPES_COUNT];
//定义音频后缀名
extern NSString *VIOCEVIDIO_TYPES[VIOCEVIDIO_COUNT];
//定义视频后缀名
extern NSString *AV_TYPES[AV_COUNT];
//定义应用后缀名
extern NSString *Application_types[Application_count];


@interface UIImage (TYHSetting)
/**
 *  将颜色转换为图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;

/**
 *  根据CJFileObjModel 返回图片
 */
+ (UIImage *)imageWithFileModel:(KsFileObjModel *)model;

/**
 *  根据CJFileObjModel 返回图片（查看文件时候用到）
 */
+ (UIImage *)imageWithFileModelOnCheck:(KsFileObjModel *)model;
@end
