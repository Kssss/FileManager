//
//  UnOpenFileView.m
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "VeUnOpenFileView.h"
#import "Masonry.h"
#import "VeFileObjModel.h"
#import "UIImage+TYHSetting.h"

#define color01a  [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]

@interface VeUnOpenFileView ()
@property (nonatomic,strong) UIImageView *fileImage;
@property (nonatomic,strong) UILabel * fileName;
@property (nonatomic,strong) UILabel *fileSize;
@property (nonatomic,strong) UILabel *descriptation;

@property (nonatomic,strong) UIButton *openOtherBtn;
@end
@implementation VeUnOpenFileView
- (instancetype)init
{
    if (self = [super init]) {
        [self setupSubView];
    }
    return self;
}
- (instancetype )initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupSubView];
    }
    return self;
}
- (void)setupSubView
{
    _fileImage = [[UIImageView alloc] init];
    
    _fileName = [[UILabel alloc] init];
    _fileName.font = [UIFont systemFontOfSize:14];
    _fileName.numberOfLines = 0;
    _fileName.textAlignment = NSTextAlignmentCenter;
    _fileSize = [[UILabel alloc] init];
    _fileSize.font = [UIFont systemFontOfSize:14];
    _fileSize.numberOfLines = 0;
    _fileSize.textAlignment = NSTextAlignmentCenter;

    _descriptation = [[UILabel alloc] init];
    _descriptation.font = [UIFont systemFontOfSize:14];
    _descriptation.numberOfLines = 0;
    _descriptation.textAlignment = NSTextAlignmentCenter;

    _openOtherBtn = [[UIButton alloc] init];
    _openOtherBtn.layer.borderColor = color01a.CGColor;
    _openOtherBtn.layer.borderWidth = 1;
    _openOtherBtn.layer.cornerRadius= 3;
    _openOtherBtn.layer.masksToBounds = YES;
    [_openOtherBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_openOtherBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_openOtherBtn setBackgroundImage:[UIImage createImageWithColor:color01a] forState:UIControlStateNormal];
    [_openOtherBtn setTitle:@"用其他方式打开" forState:UIControlStateNormal];
    
    
    [self addSubview:_fileImage];
    [self addSubview:_fileName];
    [self addSubview:_fileSize];
    [self addSubview:_descriptation];
    [self addSubview:_openOtherBtn];
    
}
- (void)setModel:(VeFileObjModel *)model
{
    _model = model;
    _fileImage.image = [UIImage imageNamed:@"fileIconOther"];
    
    _fileName.text = model.name;
    
    _fileSize.text = model.fileSize;
    _descriptation.text = @"该文件类型不支持在线浏览";
}
- (void)clickBtn:(UIButton *)btn
{
    if (_Clickblock) {
        _Clickblock(_model);
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_fileImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(100);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [_fileName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileImage.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    [_fileSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileName.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    [_descriptation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileSize.mas_bottom).offset(5);
        make.centerX.equalTo(self);
    }];
    [_openOtherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-40);
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(40);
        make.right.equalTo(self).offset(-40);
        
    }];
    
    
    
    
}
@end
