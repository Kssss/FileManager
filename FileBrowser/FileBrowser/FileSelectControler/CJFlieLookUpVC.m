//
//  FlieLookUpVC.m
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "CJFlieLookUpVC.h"
#import <QuickLook/QuickLook.h>
#import "VeUnOpenFileView.h"
#import "CJFileObjModel.h"
#import "Masonry.h"
#import "UIView+LCCategory.h"
#import "CJDownFileView.h"
@interface CJFlieLookUpVC ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong) CJFileObjModel *actualmodel;
@property (nonatomic,strong)UIDocumentInteractionController *documentInteraction;
@property (nonatomic,strong) VeUnOpenFileView *openfileView;
@property (nonatomic,strong) CJDownFileView *downView;
@end

@implementation CJFlieLookUpVC
- (instancetype)initWithFileModel:(CJFileObjModel *)fileModel;
{
    if ((fileModel.filePath == nil || [fileModel.filePath isEqualToString:@""]) && fileModel.fileUrl == nil) {
        return nil;
    }
    self = [super init];
    if (self) {
        _actualmodel = fileModel;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = (@"文件详情");
    NSFileManager *manger = [NSFileManager defaultManager];
    __weak typeof(self) weakSelf = self;
    if (_actualmodel.filePath && [manger fileExistsAtPath:_actualmodel.filePath]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //使用系统自带工具打开
            [weakSelf loadData];
        });
    }else{
        //显示下载文件视图
        [self showDownloadFile];
    }
   

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)loadData{
        _documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_actualmodel.filePath]];
        _documentInteraction.delegate = self;
        //    _documentInteraction.UTI = @"com.microsoft.ico";
        if(![_documentInteraction presentPreviewAnimated:NO]){
            [self openfileView];
            __weak CJFlieLookUpVC *weakself = self;
            _openfileView.Clickblock = ^(CJFileObjModel *model){
                [weakself.documentInteraction presentOpenInMenuFromRect:CGRectMake(0, weakself.view.height - 500, 100, 100)
                                                                 inView:weakself.view
                                                               animated:YES];
            };
        }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    _documentInteraction = nil;
}
- (void)showDownloadFile
{
    [self downView];
}
- (CJDownFileView *)downView
{
    if (_downView == nil) {
        _downView = [[CJDownFileView alloc] init];
        _downView.model = _actualmodel;
        [self.view addSubview:_downView];
        __weak typeof(self) weakself = self;
        _downView.downloadComplete = ^(CJFileObjModel *model){
            weakself.downView.hidden =YES;
            if (weakself.downloadCompleteBlock) {
                weakself.downloadCompleteBlock(model);
            }
            [weakself loadData];
        };
    }
    return _downView;
}
- (VeUnOpenFileView *)openfileView
{
    if (_openfileView == nil) {
        _openfileView = [[VeUnOpenFileView alloc] init];
        _openfileView.model =_actualmodel;
        [self.view addSubview:_openfileView];
    }
    return _openfileView;
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    __weak typeof(self) weakSelf = self;
    [_openfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        weakSelf.openfileView.backgroundColor = [UIColor whiteColor];
        
    }];
    [_downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        weakSelf.downView.backgroundColor = [UIColor whiteColor];
    }];
}
#pragma mark -UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}
- (nullable UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;

}
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
