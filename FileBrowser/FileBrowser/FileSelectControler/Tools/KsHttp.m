//
//  CJHttp.m
//  Antenna
//
//  Created by Lc on 16/6/13.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "KsHttp.h"

@implementation KsHttp
+ (instancetype)shareInstance
{
    static KsHttp *baseTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseTool = [[self alloc] initWithBaseURL:nil sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        baseTool.requestSerializer.timeoutInterval = 60;
        baseTool.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain" ,@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    });
    
    return baseTool;
}
@end
