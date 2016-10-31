//
//  FileViewCell.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "VeFileViewCell.h"
#import "Masonry.h"
#import "CJFileObjModel.h"
#import "UIColor+CJColorCategory.h"
@interface VeFileViewCell ()
@property (nonatomic,strong) UIImageView *headImagV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIButton *sendBtn;
@end
@implementation VeFileViewCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _headImagV = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;

        _titleLabel.numberOfLines = 1;
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.numberOfLines = 1;
        _detailLabel.lineBreakMode=NSLineBreakByTruncatingMiddle;
        
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setImage:[UIImage imageNamed:@"未选-10"] forState:UIControlStateNormal];
        [_sendBtn setImage:[UIImage imageNamed:@"选中-10"] forState:UIControlStateSelected];

        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [_sendBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_headImagV];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_detailLabel];
        [self.contentView addSubview:_sendBtn];
    }
    return self;
}
- (void)setModel:(CJFileObjModel *)model
{
    _model = model;
    self.headImagV.image = model.image;
    self.titleLabel.text = model.name;
    self.detailLabel.text = [model.creatTime stringByAppendingString:[NSString stringWithFormat:@"   %@",model.fileSize]];
    self.sendBtn.selected = model.select;
    
}
- (void)clickBtn:(UIButton *)btn
{

        btn.selected = !btn.selected;
        self.model.select = btn.selected;
        if (_Clickblock) {
            _Clickblock(_model,btn);
        }

}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat margin = 12;
    CGFloat w = 48;
    CGFloat h = 48;
    [_headImagV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(margin);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(w, h));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImagV.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY).offset(-10);
        make.right.equalTo(self.sendBtn.mas_left).offset(-margin);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImagV.mas_right).offset(10);
        make.centerY.equalTo(self.mas_centerY).offset(10);
        make.right.equalTo(self.sendBtn.mas_left).offset(-margin);
    }];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-margin);
        make.centerY.equalTo(self.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}
@end
