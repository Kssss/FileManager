//
//  UnOpenFileView.m
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "VeUnOpenFileView.h"
#import "Masonry.h"
#import "CJFileObjModel.h"
#import "UIImage+TYHSetting.h"
#import "UIColor+CJColorCategory.h"
static const UInt8 IMAGES_TYPES_COUNT = 8;
static const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg",@",JPG", @"jpeg", @"JPEG" ,@"gif", @"GIF"};

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

    self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    _fileImage = [[UIImageView alloc] init];
    
    _fileName = [[UILabel alloc] init];
    _fileName.font = [UIFont systemFontOfSize:15];
    _fileName.textColor = [UIColor colorWithHexString:@"333333"];
    _fileName.numberOfLines = 0;
    _fileName.textAlignment = NSTextAlignmentCenter;
    _fileSize = [[UILabel alloc] init];
    _fileSize.font = [UIFont systemFontOfSize:12];
    _fileSize.textColor = [UIColor colorWithHexString:@"999999"];
    _fileSize.numberOfLines = 0;
    _fileSize.textAlignment = NSTextAlignmentCenter;

    _descriptation = [[UILabel alloc] init];
    _descriptation.font = [UIFont systemFontOfSize:14];
    _descriptation.textColor = [UIColor colorWithHexString:@"999999"];
    _descriptation.numberOfLines = 0;
    _descriptation.textAlignment = NSTextAlignmentCenter;

    _openOtherBtn = [[UIButton alloc] init];
    _openOtherBtn.layer.borderColor = color01a.CGColor;
    _openOtherBtn.layer.borderWidth = 1;
    _openOtherBtn.layer.cornerRadius= 3;
    _openOtherBtn.layer.masksToBounds = YES;
    _openOtherBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_openOtherBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_openOtherBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [_openOtherBtn setBackgroundImage:[UIImage createImageWithColor:color01a] forState:UIControlStateNormal];
    [_openOtherBtn setTitle:(@"用其他方式打开") forState:UIControlStateNormal];
    
    
    [self addSubview:_fileImage];
    [self addSubview:_fileName];
    [self addSubview:_fileSize];
    [self addSubview:_descriptation];
    [self addSubview:_openOtherBtn];
    
}
- (void)setModel:(CJFileObjModel *)model
{
    _model = model;
    NSArray *imageTypesArray = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];

    if([imageTypesArray containsObject: [_model.fileUrl pathExtension]] || _model.image){
        
//        [_fileImage sd_setImageWithURL:[NSURL URLWithString:_model.fileUrl] placeholderImage:_model.image];
        _fileImage.image = _model.image;

    }else {
        _fileImage.image = [UIImage imageWithFileModelOnCheck:model];
    }
    
    _fileName.text = model.name;
    
    _fileSize.text = model.fileSize;
    _descriptation.text = (@"文件暂不支持本地查看，请用其他应用打开");
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
        make.top.equalTo(self).offset(80);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(166/2.0, 134/2.0));
    }];
    [_fileName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileImage.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    [_fileSize mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileName.mas_bottom).offset(10);
        make.centerX.equalTo(self);
    }];
    [_descriptation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileSize.mas_bottom).offset(40);
        make.centerX.equalTo(self);
    }];
    [_openOtherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
        make.height.mas_equalTo(44);
        make.left.equalTo(self).offset(32);
        make.right.equalTo(self).offset(-32);
        
    }];
    
    
    
    
}
@end
