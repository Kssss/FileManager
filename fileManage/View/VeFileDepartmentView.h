//
//  CJDepartmentView.h
//  Antenna
//
//  Created by HHLY on 16/6/15.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CJDepartmentViewDelegate <NSObject>

- (void)didScrollToIndex:(NSInteger)index;

@end

///总部门视图(联系人上导航视图)
@interface VeFileDepartmentView : UIScrollView

@property (strong, nonatomic) NSArray *departmentArr;//!< 部门对象集合

@property (assign, nonatomic) id<CJDepartmentViewDelegate> cj_delegate;

/** 初始化总部门视图 */
- (instancetype)initWithParts:(NSArray *)partArr;
- (instancetype)initWithParts:(NSArray *)partArr withFrame:(CGRect)frame;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

- (void)reloadData;

@end
