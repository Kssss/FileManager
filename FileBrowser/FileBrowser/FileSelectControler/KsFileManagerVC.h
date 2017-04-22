//
//  ViewController.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KsFileObjModel;
@protocol FileSelectVcDelegate <NSObject>
@required
//点击发送的事件
- (void)fileViewControlerSelected:(NSArray <KsFileObjModel *> *)fileModels;
@end
@interface KsFileManagerVC : UIViewController
@property (nonatomic,weak) id<FileSelectVcDelegate> fileSelectVcDelegate;
@end


