//
//  FileObjModel.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//  文件模型

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MKFileType) {
    
    MKFileTypeUnknown = -1, //其他
    
    MKFileTypeAll = 0, //所有

    MKFileTypeImage = 1, //图片
    
    MKFileTypeTxt = 2, //文档
    
    MKFileTypeAudioVidio = 3, //音乐视频
    
    MKFileTypeApplication = 4, //应用
    
    MKFileTypeDirectory = 5, //目录

};
@interface CJFileObjModel : NSObject

-(instancetype)initWithFilePath:(NSString *)filePath;

//文件路径
@property (copy, nonatomic) NSString *filePath;
//文件URL
@property (copy, nonatomic) NSString *fileUrl;

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *fileSize;
@property (nonatomic, assign) CGFloat fileSizefloat;

@property (copy, nonatomic) NSString *creatTime;

//图标
@property (strong, nonatomic) UIImage *image;

@property (assign, nonatomic) MKFileType fileType;
@property (nonatomic,assign) BOOL select;//是否被选中
//
///**
// *  获取路径下所有某类型的文件
// *
// *  @param path     路径
// *  @param fileType 文件类型
// *
// *  @return 文件路径集合
// */
//+(NSArray<NSString *> *)getFilesInPath:(NSString *)path fileType:(MKFileType)fileType;
//
//
///**
// *  获取当前文件所在目录所有相同类型的文件集合
// *
// *  @return 文件路径集合
// */
//-(NSArray<NSString *> *)getDirectoryFiles;

@end
