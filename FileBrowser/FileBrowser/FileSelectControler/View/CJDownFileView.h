//
//  CJDownFileView.h
//  Antenna
//
//  Created by Vieene on 2016/10/26.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJFileObjModel;

@interface CJDownFileView : UIView
//下载完成回调
@property (nonatomic,copy) void (^downloadComplete)(CJFileObjModel *model);

@property (nonatomic,strong) CJFileObjModel *model;
@end
