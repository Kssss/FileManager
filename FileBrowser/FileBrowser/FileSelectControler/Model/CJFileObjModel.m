//
//  FileObjModel.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "CJFileObjModel.h"
#import "UIImage+TYHSetting.h"
static const UInt8 IMAGES_TYPES_COUNT = 8;
static const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg",@",JPG", @"jpeg", @"JPEG" ,@"gif", @"GIF"};

@implementation CJFileObjModel
{
    NSFileManager *fileMgr;
}

-(instancetype)init {
    if(self = [super init]) {
        fileMgr = [NSFileManager defaultManager];
    }
    return self;
}

-(instancetype)initWithFilePath:(NSString *)filePath {
    if(self = [self init]){
        self.filePath = filePath;
    }
    return self;
}


-(void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    
    self.name = [filePath lastPathComponent];
    
    BOOL isDirectory = true;
    [fileMgr fileExistsAtPath: filePath isDirectory: &isDirectory];
    self.image = [UIImage imageNamed: @"fielIcon"];
    self.fileType = MKFileTypeUnknown;
    
    if(isDirectory){
        self.image = [UIImage imageNamed: @"dirIcon"];
        self.fileType = MKFileTypeDirectory;
    }else{
        
        NSArray *imageTypesArray = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
     
        if([imageTypesArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageWithContentsOfFile: filePath];
            self.fileType = MKFileTypeUnknown;
        }else {
            self.image =[UIImage imageWithFileModel:self];
        }
        
    
    NSError *error = nil;
    NSDictionary *fileAttributes = [fileMgr attributesOfItemAtPath:filePath error:&error];
    
    if (fileAttributes != nil) {
        NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
        NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
        NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
        if (fileSize) {
            CGFloat size = [fileSize unsignedLongLongValue];
            self.fileSizefloat = size;
            NSString *sizestr = [NSString stringWithFormat:@"%qi",[fileSize unsignedLongLongValue]];
//            NSLog(@"File size: %@\n",fileSize);
            if (sizestr.length <=3) {
                self.fileSize = [NSString stringWithFormat:@"%.1f B",size];
            } else if(sizestr.length>3 && sizestr.length<7){
                self.fileSize = [NSString stringWithFormat:@"%.1f KB",size/1000.0];
            }else{
                self.fileSize = [NSString stringWithFormat:@"%.1f M",size/(1000.0 * 1000)];
            }
        }
  
        if (fileModDate) {
            //用于格式化NSDate对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //设置格式：zzz表示时区
            [dateFormatter setDateFormat:@"MM-dd HH:mm:ss"];
            //NSDate转NSString
            self.creatTime = [dateFormatter stringFromDate:fileModDate];
        }
        if (fileCreateDate) {
//            NSLog(@"create date:%@\n", fileModDate);
        }
    }
    else {
//        NSLog(@"Path (%@) is invalid.", filePath);
    }
}
}


@end
