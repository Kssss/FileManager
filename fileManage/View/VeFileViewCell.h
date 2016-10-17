//
//  FileViewCell.h
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VeFileObjModel;
@interface VeFileViewCell : UITableViewCell
@property (nonatomic,strong)VeFileObjModel *model;
@property (nonatomic,copy) void (^Clickblock)(VeFileObjModel *model,BOOL select);

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
