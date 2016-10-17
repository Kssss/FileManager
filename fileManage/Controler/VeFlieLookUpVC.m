//
//  FlieLookUpVC.m
//  fileManage
//
//  Created by Vieene on 2016/10/14.
//  Copyright © 2016年 Vieene. All rights reserved.
//

#import "VeFlieLookUpVC.h"
#import <QuickLook/QuickLook.h>
#import "VeUnOpenFileView.h"
#import "VeFileObjModel.h"
#import "Masonry.h"
@interface VeFlieLookUpVC ()<UIDocumentInteractionControllerDelegate>
@property (nonatomic,strong) VeFileObjModel *actualmodel;
@property (nonatomic,strong)UIDocumentInteractionController *documentInteraction;
@property (nonatomic,strong) VeUnOpenFileView *openfileView;
@end

@implementation VeFlieLookUpVC
- (instancetype)initWithFileModel:(VeFileObjModel *)actualFile;
{
    if (actualFile.filePath == nil || [actualFile.filePath isEqualToString:@""]) {
        return nil;
    }
    self = [super init];
    if (self) {
        _actualmodel = actualFile;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadData];
    });

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)loadData{
    _documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:_actualmodel.filePath]];
    _documentInteraction.delegate = self;
    //    _documentInteraction.UTI = @"com.microsoft.ico";
    if(![_documentInteraction presentPreviewAnimated:YES]){
        [self openfileView];
        __weak VeFlieLookUpVC *weakself = self;
        _openfileView.Clickblock = ^(VeFileObjModel *model){
                    [weakself.documentInteraction presentOpenInMenuFromRect:CGRectMake(760, 20, 100, 100)
                                                             inView:weakself.view
                                                           animated:YES];
        };

    }
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
    [_openfileView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view);
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        _openfileView.backgroundColor = [UIColor whiteColor];
        
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

// Preview presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller
{
    
}
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// Options menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOptionsMenu:(UIDocumentInteractionController *)controller
{
    
}
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller
{
    
}

// Open in menu presented/dismissed on document.  Use to set up any HI underneath.
- (void)documentInteractionControllerWillPresentOpenInMenu:(UIDocumentInteractionController *)controller
{
    
}
- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    
}

// Synchronous.  May be called when inside preview.  Usually followed by app termination.  Can use willBegin... to set annotation.
- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(nullable NSString *)application
{
    
}
- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(nullable NSString *)application
{
    
}



@end
