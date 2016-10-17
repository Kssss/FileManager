//
//  FileObjModel.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "VeFileObjModel.h"
const UInt8 IMAGES_TYPES_COUNT = 7;

const UInt8 TEXT_TYPES_COUNT = 10;
const UInt8 VIOCEVIDIO_COUNT = 13;
const UInt8 Application_count = 2;
const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg", @"jpeg", @"JPG", @"gif", @"GIF"};
const NSString *TEXT_TYPES[TEXT_TYPES_COUNT] = {@"txt", @"TXT", @"doc", @"docx", @"html", @"js", @"xls", @"xlsx", @"ppt",@"pdf"};
const NSString *VIOCEVIDIO_TYPES[VIOCEVIDIO_COUNT] = {@"mp3",@"wav",@"CD",@"ogg",@"asf",@"wma",@"rm",@"midi",@"vqf",@"amr",@"rmvb",@"avi",@"mkv"};
const NSString *Application_types[Application_count] = {@"apk",@"ipa"};

@implementation VeFileObjModel
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

//+(NSArray<NSString *> *)getFilesInPath:(NSString *)path fileType:(MKFileType)fileType;
//{
//    NSMutableArray<NSString *> *filePaths = [NSMutableArray new];
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    BOOL isDirectory = false;
//    if([fileManager fileExistsAtPath:path isDirectory: &isDirectory]){
//        if(!isDirectory){
//            path = [path stringByDeletingLastPathComponent];
//        }
//        
//        NSArray<NSString *> *subPaths = [fileManager contentsOfDirectoryAtPath:path error:NULL];
//        for(NSString *subPath in subPaths){
////            NSArray *array = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
//            NSArray *array = [self getExtension:fileType];
//            if (array.count == 0) {//全部
//                [filePaths addObject: [NSString stringWithFormat:@"%@/%@", path, subPath]];
//            }
//            if([array containsObject: [subPath pathExtension]]){
//                [filePaths addObject: [NSString stringWithFormat:@"%@/%@", path, subPath]];
//            }
//        }
//    }
//    
//    return filePaths;
//}
////根据文件的类型返回所有的相同类型的扩展名
//+ (NSArray *)getExtension:(MKFileType)filetype
//{
//    switch (filetype) {
//        case MKFileTypeAll:
//            return @[];
//            break;
//        case MKFileTypeUnknown:
//            return nil;
//            break;
//        case MKFileTypeImage:
//            return @[@"png", @"PNG", @"jpg", @"jpeg", @"JPG", @"gif", @"GIF"];
//            break;
//        case MKFileTypeTxt:
//            return @[@"txt", @"TXT", @"doc", @"docx", @"html", @"js", @"xls", @"xlsx", @"ppt"];
//            break;
//        case MKFileTypeAudioVidio:
//            return @[@"mp3",@"wav",@"CD",@"ogg",@"asf",@"wma",@"rm",@"midi",@"vqf",@"amr",@"rmvb",@"avi",@"mkv",@"mkv"];
//            break;
//        case MKFileTypeApplication:
//            return @[@"apk",@"ipa"];
//            break;
//
//        default:
//            return @[];
//            break;
//    }
//}


//-(NSArray<NSString *> *)getDirectoryFiles
//{
//    return [FileObjModel getFilesInPath:self.filePath fileType:self.fileType];
//}

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
        NSArray *textTypesArray = [NSArray arrayWithObjects: TEXT_TYPES count: TEXT_TYPES_COUNT];
        NSArray *viceViodeArray = [NSArray arrayWithObjects: VIOCEVIDIO_TYPES count: VIOCEVIDIO_COUNT];
        NSArray *appViodeArray = [NSArray arrayWithObjects: Application_types count: Application_count];

        if([imageTypesArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageWithContentsOfFile: filePath];
            self.fileType = MKFileTypeImage;
        }else if([textTypesArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageNamed: @"fielIcon"];
            self.fileType = MKFileTypeTxt;
        }else if([viceViodeArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageNamed: @"fielIcon"];
            self.fileType = MKFileTypeAudioVidio;
          } else if([appViodeArray containsObject: [filePath pathExtension]]){
            self.image = [UIImage imageNamed: @"fielIcon"];
            self.fileType = MKFileTypeApplication;
        }else{
            self.image = [UIImage imageNamed: @"fielIcon"];
            self.fileType = MKFileTypeUnknown;
        }
    }
    NSLog(@"fileType%zd",self.fileType);
    
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
            NSLog(@"File size: %@\n",fileSize);
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
            NSLog(@"create date:%@\n", fileModDate);
        }
    }
    else {
        NSLog(@"Path (%@) is invalid.", filePath);
    }
}


@end
