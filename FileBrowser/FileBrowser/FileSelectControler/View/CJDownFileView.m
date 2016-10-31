//
//  CJDownFileView.m
//  Antenna
//
//  Created by Vieene on 2016/10/26.
//  Copyright © 2016年 HHLY. All rights reserved.
//

#import "CJDownFileView.h"
#import "CJFileObjModel.h"
#import "HSDownloadManager.h"
#import "CJFileTools.h"
#import "UIImageView+WebCache.h"
#import "NSString+hash.h"
#import "UIImage+TYHSetting.h"
#import "UIColor+CJColorCategory.h"
#import "CJHttp.h"
#import <Masonry.h>
#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CJFileCache1"]
#define HSCachesDirectory2 [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CJFileCache2"]
#define color01a  [UIColor colorWithRed:0.004 green:0.651 blue:0.996 alpha:1.000]


static const UInt8 IMAGES_TYPES_COUNT = 8;
static const NSString *IMAGES_TYPES[IMAGES_TYPES_COUNT] = {@"png", @"PNG", @"jpg",@",JPG", @"jpeg", @"JPEG" ,@"gif", @"GIF"};

@interface CJDownFileView ()
@property (nonatomic,strong) UIImageView *fileImage;
@property (nonatomic,strong) UILabel * fileName;
@property (nonatomic,strong) UILabel *fileSize;
@property (nonatomic,strong) UIProgressView *downProgressView;
@property (nonatomic,strong) UIButton  *startBtn;

@property (nonatomic,strong) UIButton  *cancleBtn;

@end
@implementation CJDownFileView
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
    
    _downProgressView = [[UIProgressView alloc] init];
    _downProgressView.progressTintColor = color01a;
    _downProgressView.trackTintColor = [UIColor grayColor];
    
    _startBtn = [[UIButton alloc] init];
    _startBtn.layer.borderColor = color01a.CGColor;
    _startBtn.layer.borderWidth = 1;
    _startBtn.layer.cornerRadius= 3;
    _startBtn.layer.masksToBounds = YES;
    _startBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [_startBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [_startBtn setBackgroundImage:[UIImage createImageWithColor:color01a] forState:UIControlStateNormal];
    [_startBtn setTitle:(@"点击下载") forState:UIControlStateNormal];

    
    _cancleBtn = [[UIButton alloc] init];

    [_cancleBtn addTarget:self action:@selector(startDownloadFile) forControlEvents:UIControlEventTouchUpInside];

    
    [self addSubview:_fileImage];
    [self addSubview:_fileName];
    [self addSubview:_fileSize];
    [self addSubview:_downProgressView];
    [self addSubview:_cancleBtn];
    [self addSubview:_startBtn];
    
}
- (void)setModel:(CJFileObjModel *)model
{
    _model = model;
    NSArray *imageTypesArray = [NSArray arrayWithObjects: IMAGES_TYPES count: IMAGES_TYPES_COUNT];
    
    if([imageTypesArray containsObject: [_model.fileUrl pathExtension]] || _model.image){
        
        [_fileImage sd_setImageWithURL:[NSURL URLWithString:_model.fileUrl] placeholderImage:_model.image];
        
    }else {
        _fileImage.image = [UIImage imageWithFileModelOnCheck:model];
    }
    _fileName.text = model.name;
    
    _fileSize.text = model.fileSize;
    
    if([CJHttp shareInstance].reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi){
        _downProgressView.hidden = NO;
        _startBtn.hidden = YES;
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf startDownloadFile];
        });
    }else{
        _downProgressView.hidden = YES;
        _startBtn.hidden = NO;
    }
  
}
- (void)clickBtn:(UIButton *)btn
{
    _downProgressView.hidden = NO;
    _startBtn.hidden = YES;
    [self startDownloadFile];
}
- (void)startDownloadFile
{
//    [[HSDownloadManager sharedInstance] deleteAllFile];
    __weak typeof(self) weakSelf = self;

    [[HSDownloadManager sharedInstance] download:_model.fileUrl progress:^(NSInteger receivedSize, NSInteger expectedSize, CGFloat progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.downProgressView.progress = progress;
        });
    } state:^(DownloadState state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (state) {
                case DownloadStateStart:
                    [weakSelf.cancleBtn setImage:[UIImage imageNamed:@"pause_320"] forState:UIControlStateNormal];
                    break;
                    case DownloadStateSuspended:
                    [weakSelf.cancleBtn setImage:[UIImage imageNamed:@"Play_378"] forState:UIControlStateNormal];
                    break;
                    case DownloadStateCompleted:
                {              weakSelf.cancleBtn.hidden = YES;
                    [weakSelf copyFileToCache];
                    if (weakSelf.downloadComplete) {
                        weakSelf.downloadComplete(weakSelf.model);
                    }
                }   break;
                    case DownloadStateFailed:
                    [weakSelf.cancleBtn setImage:[UIImage imageNamed:@"error_128"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        });
    }];
}
- (void)copyFileToCache
{
//  原始文件名
    NSString *originName = [HSCachesDirectory2 stringByAppendingPathComponent:[_model.fileUrl md5String]];
//  目标文件
    NSString *destination = [HomeFilePath stringByAppendingPathComponent:_model.name];
    destination =  [CJFileTools checkFileName:destination];
    _model.filePath = destination;
    BOOL reult =  [CJFileTools copyFile:originName to:destination];
    
    NSLog(@"文件复制的结果：reult %d",reult);
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
    [_downProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileSize.mas_bottom).offset(24);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(4);
        make.left.equalTo(self).offset(70);
        make.right.equalTo(self).offset(-70);
    }];
    [_startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fileSize.mas_bottom).offset(40);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(40);
        make.left.equalTo(self).offset(70);
        make.right.equalTo(self).offset(-70);
    }];
    [_cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downProgressView);
        make.left.equalTo(self.downProgressView.mas_right).offset(5);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
}

@end
