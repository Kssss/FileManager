//
//  FlieLookUpVC.h
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KsFileObjModel;
@interface KsFlieLookUpVC : UIViewController
@property (nonatomic,copy) void (^downloadCompleteBlock)(KsFileObjModel *model);

- (instancetype)initWithFileModel:(KsFileObjModel *)fileModel;

@end
