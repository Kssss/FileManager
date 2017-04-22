//
//  CJDepartmentView.m
//  Antenna
//
//  Created by HHLY on 16/6/15.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "KsFileDepartmentView.h"
#import "Masonry.h"
#import "UIColor+CJColorCategory.h"
#define DepartmentWidth [UIScreen mainScreen].bounds.size.width/4.0
#define CJWeakSelf __weak typeof(self) weakSelf = self
#define CJScreenWidth  [UIScreen mainScreen].bounds.size.width
#define color01a  [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]

@interface KsFileDepartmentView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIView *indicatorView;
@property (assign, nonatomic) NSInteger selectedIndex;

@end

@implementation KsFileDepartmentView

#pragma mark - Lazy
- (UIView *)indicatorView {
    if (!_indicatorView) {
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0,46, DepartmentWidth, 2)];
        _indicatorView.backgroundColor = [UIColor colorWithHexString:@"22aeff"];
    }
    return _indicatorView;
}

#pragma mark - Property
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    UIButton *lastBtn = [self viewWithTag:100+_selectedIndex];
    UIButton *btn = [self viewWithTag:100+selectedIndex];
    lastBtn.selected = NO;
    btn.selected = YES;
    _selectedIndex = selectedIndex;
    [UIView animateWithDuration:0.15 animations:^{
        self.indicatorView.frame = CGRectMake(CGRectGetMinX(btn.frame) + 1, (46), CGRectGetWidth(btn.frame), 2);
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.selectedIndex == 0) {
                [self setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            else {
                [self scrollRightPosition];
            }
        }
    }];
}

- (void)reloadData {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self initializeSubviews];
}

#pragma mark - Initialize
- (instancetype)init {
    return [self initWithParts:nil withFrame:CGRectZero];
}

- (instancetype)initWithParts:(NSArray *)partArr {
    return [self initWithParts:partArr withFrame:CGRectZero];
}

- (instancetype)initWithParts:(NSArray *)partArr withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.departmentArr = partArr;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor grayColor];
        
        [self initializeSubviews];
    }
    return self;
}

- (void)initializeSubviews {
    
    UIButton *lastBtn = nil;
    CJWeakSelf;
    CGFloat totalWidth = 0;
    for (int i = 0; i < self.departmentArr.count; ++i) {
        NSString *title = self.departmentArr[i];
        
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        
        UIButton *partBtn = [[UIButton alloc] init];
        partBtn.tag = 100 + i;
        [partBtn setTitle:title forState:UIControlStateNormal];
        [partBtn setTitle:title forState:UIControlStateSelected];
        
        [partBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [partBtn setTitleColor:[UIColor colorWithHexString:@"22aeff"]  forState:UIControlStateSelected];
        [partBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [partBtn addTarget:self action:@selector(clickDepartmentButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:partBtn];
        
        if (i == 0) {
            partBtn.selected = YES;
        }
        
        CGFloat buttonWidth = size.width > DepartmentWidth ? size.width + 2: DepartmentWidth;
        totalWidth += buttonWidth;
        
        [partBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.width.mas_equalTo(buttonWidth);
            make.height.mas_equalTo((48));
            
            if (lastBtn) {
                make.left.equalTo(lastBtn.mas_right);//.offset(2);
            }
            else {
                make.left.equalTo(weakSelf);//.offset(2);
            }
        }];
        lastBtn = partBtn;
    }
    
    [self addSubview:self.indicatorView];
    
    self.bounces = NO;
    self.delegate = self;
    
    self.contentSize = CGSizeMake(totalWidth > CJScreenWidth ? totalWidth: CJScreenWidth, CGRectGetHeight(self.bounds));
}

#pragma mark - Actions
- (void)clickDepartmentButton:(UIButton *)sender {
    self.selectedIndex = sender.tag - 100;
    if ([self.delegate respondsToSelector:@selector(didScrollToIndex:)]) {
        [self.delegate didScrollToIndex:self.selectedIndex];
    }
}

- (void)scrollRightPosition {
    UIButton *btn = [self viewWithTag:100 + self.selectedIndex - 1];
    if (btn) {
        UIButton *lastBtn = [self viewWithTag:100 + self.departmentArr.count - 1];
        if (CGRectGetMaxX(lastBtn.frame) - CGRectGetMinX(btn.frame) <= CJScreenWidth) {
            [self setContentOffset:CGPointMake(self.contentSize.width - CJScreenWidth, 0) animated:YES];
            return;
        }
        [self setContentOffset:CGPointMake(CGRectGetMinX(btn.frame), 0) animated:YES];
    }
}

@end
