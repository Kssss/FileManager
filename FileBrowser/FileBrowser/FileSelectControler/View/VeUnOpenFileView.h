//
//  UnOpenFileView.h
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJFileObjModel;
@interface VeUnOpenFileView : UIView
@property (nonatomic,copy) void (^Clickblock)(CJFileObjModel *model);

@property (nonatomic,strong) CJFileObjModel *model;
@end
