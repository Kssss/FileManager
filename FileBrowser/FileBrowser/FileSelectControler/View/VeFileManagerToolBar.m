//
//  TYHInternalAssetGridToolBar.m
//  TaiYangHua
//
//  Created by Lc on 16/2/17.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import "VeFileManagerToolBar.h"
#import "UIImage+TYHSetting.h"
#import "CJFileObjModel.h"
#import "Masonry.h"
#import "UIColor+CJColorCategory.h"
#define color01a  [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]

@interface VeFileManagerToolBar ()
@property (weak, nonatomic) UIButton *senderButton;
@property (weak, nonatomic) UILabel *originalLabel;
@property (assign, nonatomic) NSInteger bytes;
@end

@implementation VeFileManagerToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectedItems = @[].mutableCopy;
        [self originalLabel];
        [self senderButton];
    }
    return self;
}

#pragma mark - lazy
- (UILabel *)originalLabel
{
    if (!_originalLabel) {
        UILabel *originalLabel = [[UILabel alloc] init];
        [originalLabel setFont:[UIFont systemFontOfSize:13]];
        [originalLabel setTextColor:[UIColor colorWithHexString:@"666666"]];
        _originalLabel = originalLabel;
        [self addSubview:_originalLabel];
    }
    
    return _originalLabel;
}

- (UIButton *)senderButton
{
    if (!_senderButton) {
        UIButton *senderButton = [[UIButton alloc] init];
        [senderButton setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"22aeff"]] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
        [senderButton setTitle:(@"发送") forState:UIControlStateDisabled];
        [senderButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [senderButton.layer setCornerRadius:5];
        [senderButton.layer setMasksToBounds:YES];
        [senderButton setEnabled:NO];
        [senderButton addTarget:self action:@selector(clickSenderButton:) forControlEvents:UIControlEventTouchUpInside];
        _senderButton = senderButton;
        [self addSubview:_senderButton];
    }
    
    return _senderButton;
}

#pragma mark - allButton Action
- (void)clickOriginalButton:(UIButton *)button
{
    button.selected = !button.isSelected;
    [self calculateAllselectedItemsBytes];
}

- (void)clickSenderButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didClickSenderButtonInAssetGridToolBar:)]) {
        [self.delegate didClickSenderButtonInAssetGridToolBar:self];
    }
}

- (void)setSelectedItems:(NSMutableArray *)selectedItems
{
     _selectedItems = selectedItems;
    
    // 按钮能否点击
    self.senderButton.enabled = selectedItems.count > 0 ? YES : NO;
    // 按钮是否显示
    if (selectedItems.count > 0) [self.senderButton setTitle:[NSString stringWithFormat:@"%@(%ld)", @"发送", selectedItems.count] forState:UIControlStateNormal];
    // 显示大小
    [self calculateAllselectedItemsBytes];
}

// 计算所有选中文件的大小
- (void)calculateAllselectedItemsBytes
{
        __block NSInteger dataLength = 0;
        __block NSInteger lastSelectedItem = 0;
        NSString *bytes = nil;

        for (CJFileObjModel *fileObj in self.selectedItems) {
            lastSelectedItem++;
            dataLength += fileObj.fileSizefloat;
            
        }
        if (lastSelectedItem == self.selectedItems.count) {
            //                NSString *bytes = nil;
            if (dataLength >= 0.1 * (1000 * 1000)) {
                bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1000/1000.0];
            } else if (dataLength >= 1000) {
                bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1000.0];
            } else {
                bytes = [NSString stringWithFormat:@"%zdB",dataLength];
            }
            
            
        }
    if ([bytes isEqualToString:@"0B"]) {
        self.originalLabel.hidden = YES;
    }else{
        self.originalLabel.hidden = NO;
    }
        self.originalLabel.text = [NSString stringWithFormat:@"总文件大小约(%@)", bytes];


}

#pragma mark - layoutSubviews
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_originalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(12);
    }];
    [_originalLabel sizeToFit];
    [_senderButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self);
        make.height.equalTo(@(29));
        make.width.equalTo(@(68));
    }];
}

@end
