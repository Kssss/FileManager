//
//  UnOpenFileView.h
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KsFileObjModel;
@interface KsUnOpenFileView : UIView
@property (nonatomic,copy) void (^Clickblock)(KsFileObjModel *model);

@property (nonatomic,strong) KsFileObjModel *model;
@end
