//
//  UIImage+TYHSetting.h
//  TaiYangHua
//
//  Created by Lc on 15/12/25.
//  Copyright © 2015年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJSession,CJFileObjModel;
@interface UIImage (TYHSetting)
/**
 *  将颜色转换为图片
 */
+ (UIImage *)createImageWithColor:(UIColor*) color;

/**
 *  根据CJsession返回图片
 */
+ (UIImage *)imageWithModel:(CJSession * )session;

/**
 *  根据CJFileObjModel 返回图片
 */
+ (UIImage *)imageWithFileModel:(CJFileObjModel *)model;

/**
 *  根据CJFileObjModel 返回图片（查看文件时候用到）
 */
+ (UIImage *)imageWithFileModelOnCheck:(CJFileObjModel *)model;
@end
