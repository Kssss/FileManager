//
//  FileViewCell.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KsFileObjModel;
@interface KsFileViewCell : UITableViewCell
@property (nonatomic,strong)KsFileObjModel *model;
@property (nonatomic,copy) void (^Clickblock)(KsFileObjModel *model,UIButton *btn);

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
