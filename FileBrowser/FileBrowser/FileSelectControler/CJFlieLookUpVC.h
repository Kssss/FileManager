//
//  FlieLookUpVC.h
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJFileObjModel;
@interface CJFlieLookUpVC : UIViewController
@property (nonatomic,copy) void (^downloadCompleteBlock)(CJFileObjModel *model);

- (instancetype)initWithFileModel:(CJFileObjModel *)fileModel;

@end
