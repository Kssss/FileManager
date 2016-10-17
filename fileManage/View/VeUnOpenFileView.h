//
//  UnOpenFileView.h
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VeFileObjModel;
@interface VeUnOpenFileView : UIView
@property (nonatomic,copy) void (^Clickblock)(VeFileObjModel *model);

@property (nonatomic,strong) VeFileObjModel *model;
@end
