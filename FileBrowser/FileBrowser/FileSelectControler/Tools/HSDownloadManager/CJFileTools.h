//
//  CJFileTools.h
//  Antenna
//
//  Created by Vieene on 2016/10/26.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJFileTools : NSObject
//移动文件到另一个文件夹下
+ (BOOL)moveFile:(NSString *)filePath to:(NSString *)path;
//移动文件到另一个文件夹下
+ (BOOL)copyFile:(NSString *)filePath to:(NSString *)path;
//检查名字，对于已经存在的文件，使用（1）添加后缀
+ (NSString *)checkFileName:(NSString *)destinationPath;


@end
