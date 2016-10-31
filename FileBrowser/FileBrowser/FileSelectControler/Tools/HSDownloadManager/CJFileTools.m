//
//  CJFileTools.m
//  Antenna
//
//  Created by Vieene on 2016/10/26.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "CJFileTools.h"

@implementation CJFileTools
//移动文件到另一个文件夹下
+ (BOOL)moveFile:(NSString *)filePath to:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if([self creatFileDirection:path.stringByDeletingLastPathComponent]){
        NSError *error;
        BOOL result =  [fileManager moveItemAtPath:filePath toPath:path error:&error];
        if (error) {
            NSLog(@"------moveFile ERROR-%@",error);
        }
        return result;
        
    }
    return NO;
}
+ (BOOL)copyFile:(NSString *)filePath to:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([self creatFileDirection:path.stringByDeletingLastPathComponent ]){
        NSError *error;
        BOOL result =  [fileManager copyItemAtPath:filePath toPath:path error:&error];
        if (error) {
            NSLog(@"------copyItemAtPath ERROR-%@",error);
        }
        return result;
    }
    return NO;
}

+ (BOOL)creatFileDirection:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
       return  [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return YES;
}
+ (NSString *)checkFileName:(NSString *)destinationPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //
    BOOL isDirection;
    BOOL exist = [fileManager fileExistsAtPath:destinationPath isDirectory:&isDirection];
    if (exist) {
        NSArray *componentsArray = destinationPath.pathComponents;
        NSArray *nameArray = [componentsArray.lastObject componentsSeparatedByString:@"."];
        NSString *name = [nameArray firstObject];
        NSString *estension = [nameArray lastObject];
        for (int a = 1 ; a <100; a++) {
            
            NSString * tempName = [name stringByAppendingString:[NSString stringWithFormat:@"(%d)",a]];
            NSString * twoName = [tempName stringByAppendingFormat:@".%@",estension];
            NSMutableArray *array = [NSMutableArray arrayWithArray:componentsArray.mutableCopy];
            [array removeLastObject];
            [array addObject:twoName];
            NSString *twoPath = [NSString pathWithComponents:array];
            if ([fileManager fileExistsAtPath:twoPath isDirectory:&isDirection]) {
                continue;
            }else{
                return twoPath;
                break;
            }
        }
    }else{
        NSLog(@"没有发现重命的文件");
    }
    return destinationPath;
}
@end
