//
//  TYHInternalAssetGridToolBar.h
//  TaiYangHua
//
//  Created by Lc on 16/2/17.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KsFileManagerToolBar;
@class KsFileObjModel;
@protocol KsInternalAssetGridToolBarDelegate <NSObject>

@required

- (void)didClickSenderButtonInAssetGridToolBar:(KsFileManagerToolBar *)internalAssetGridToolBar;

@end

@interface KsFileManagerToolBar : UIView


/**
 选中的文件 数组<KsFileObjModel>
 */
@property (strong, nonatomic) NSMutableArray <KsFileObjModel *> * selectedItems;

@property (weak, nonatomic) id<KsInternalAssetGridToolBarDelegate> delegate;

@end

