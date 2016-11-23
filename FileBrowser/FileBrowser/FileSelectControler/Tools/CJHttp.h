//
//  CJHttp.h
//  Antenna
//
//  Created by Lc on 16/6/13.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface CJHttp : AFHTTPSessionManager
+ (instancetype)shareInstance;

@end
