//
//  KsDownFileView.h
//  Antenna
//
//  Created by Vieene on 2016/10/26.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KsFileObjModel;

@interface KsDownFileView : UIView
//下载完成回调
@property (nonatomic,copy) void (^downloadComplete)(KsFileObjModel *model);

@property (nonatomic,strong) KsFileObjModel *model;
@end
