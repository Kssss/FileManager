//
//  ViewController.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJFileObjModel;
@protocol FileSelectVcDelegate <NSObject>
@required
//点击发送的事件
- (void)fileViewControlerSelected:(NSArray <CJFileObjModel *> *)fileModels;
@end
@interface CJFileManagerVC : UIViewController
@property (nonatomic,weak) id<FileSelectVcDelegate> fileSelectVcDelegate;
@end


