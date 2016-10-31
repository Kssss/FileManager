//
//  FileViewCell.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CJFileObjModel;
@interface VeFileViewCell : UITableViewCell
@property (nonatomic,strong)CJFileObjModel *model;
@property (nonatomic,copy) void (^Clickblock)(CJFileObjModel *model,UIButton *btn);

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
