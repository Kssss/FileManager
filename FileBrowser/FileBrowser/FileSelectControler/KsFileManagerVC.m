//
//  ViewController.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

//文件管理器默认管理的路径
#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CJFileCache1"]

//设置发送的文件的最大空间5MB
#define FileMaxSize 5000000
///屏幕高度/宽度
#define CJScreenWidth        [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight       [UIScreen mainScreen].bounds.size.height
#import "KsFileManagerVC.h"
#import "KsFileObjModel.h"
#import "KsFileViewCell.h"
#import "KsFileManagerToolBar.h"
#import "KsFileDepartmentView.h"
#import "KsFlieLookUpVC.h"
#import "UIView+CJToast.h"
#import "CFScreenSizeManager.h"

CGFloat departmentH = 48;
CGFloat toolBarHeight = 49;

@interface KsFileManagerVC ()<UITableViewDelegate,UITableViewDataSource,KsInternalAssetGridToolBarDelegate,KsDepartmentViewDelegate>
@property (strong, nonatomic) KsFileDepartmentView *departmentView;//文件的类目视图
@property (strong, nonatomic) KsFileManagerToolBar *assetGridToolBar;//底部发送的工具条
@property (strong, nonatomic) NSMutableArray *selectedItems;//记录选中的cell的模型
@property (nonatomic,strong) UITableView *tabvlew;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *originFileArray;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteraction;
@property (nonatomic,strong) NSArray *depatmentArray;//文件分类数组
@end

@implementation KsFileManagerVC
+ (void)initialize
{
    //创建管理目录
    [self getHomeFilePath];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的文件";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //关闭tabview自动偏移
    if (@available(iOS 11.0, *)) {
        self.tabvlew.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //加载数据源
    [self loadData];
    //加载tabView
    [self tabvlew];
    //加载文件内容分组视图
    [self departmentView];
    //加载工具条
    [self assetGridToolBar];
    
    NSLog(@"文件默认存储的路径---%@",HomeFilePath);
}
- (NSArray *)depatmentArray
{
    if (_depatmentArray == nil) {
        _depatmentArray = @[@"全部",@"音乐",@"文档",@"应用",@"其他"];
    }
    return  _depatmentArray;
}
#pragma mark - lazy
- (UITableView *)tabvlew
{
    if (_tabvlew == nil) {
        CGRect frame = CGRectMake(0,[CFScreenSizeManager navigationBarHeight] + departmentH + 5, CJScreenWidth, CJScreenHeight  - toolBarHeight - departmentH - 10);
        _tabvlew = [[UITableView alloc]   initWithFrame:frame style:UITableViewStylePlain];
        _tabvlew.tableFooterView = [[UIView alloc] init];
        _tabvlew.delegate = self;
        _tabvlew.dataSource = self;
        _tabvlew.bounces = YES;
        [self.view addSubview:self.tabvlew];
    }
    return _tabvlew;
}
- (KsFileManagerToolBar *)assetGridToolBar
{
    if (_assetGridToolBar == nil) {
        KsFileManagerToolBar *toolbar = [[KsFileManagerToolBar alloc] initWithFrame:CGRectMake(0, CJScreenHeight - toolBarHeight, CJScreenWidth, toolBarHeight)];
        toolbar.delegate = self;
        _assetGridToolBar = toolbar;
        _assetGridToolBar.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_assetGridToolBar];
        
    }
    return _assetGridToolBar;
}
- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = @[].mutableCopy;
    }
    return _selectedItems;
}

- (KsFileDepartmentView *)departmentView
{
    if (_departmentView == nil) {
        CGRect frame = CGRectMake(0, [CFScreenSizeManager navigationBarHeight], CJScreenWidth, departmentH);
        _departmentView = [[KsFileDepartmentView alloc] initWithParts:self.depatmentArray withFrame:frame];
        _departmentView.delegate = self;
        [self.view addSubview:_departmentView];
    }
    return _departmentView;
}
#pragma mark - 加载数据
- (void)loadData{
    [_dataSource removeAllObjects];
    self.originFileArray = @[].mutableCopy;
    self.view.backgroundColor = [UIColor whiteColor];
    //默认加入几个文件（演示作用）
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"宋冬野 - 董小姐" ofType:@"mp3"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"IMG_4143" ofType:@"PNG"];
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"angle" ofType:@"jpg"];
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"he is a pirate" ofType:@"mp3"];
    
    KsFileObjModel *mode1 = [[KsFileObjModel alloc] initWithFilePath:path1];
    KsFileObjModel *mode2 = [[KsFileObjModel alloc] initWithFilePath:path2];
    KsFileObjModel *mode3 = [[KsFileObjModel alloc] initWithFilePath:path3];
    KsFileObjModel *mode4 = [[KsFileObjModel alloc] initWithFilePath:path4];
    
    [self.originFileArray addObjectsFromArray:@[mode1,mode2,mode3,mode4]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //遍历HomeFilePath文件夹下的子文件
    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath:HomeFilePath error: NULL];
    for(NSString *str in subPathsArray){
        KsFileObjModel *object = [[KsFileObjModel alloc] initWithFilePath: [NSString stringWithFormat:@"%@/%@",HomeFilePath, str]];
        [self.originFileArray addObject: object];
    }
    self.dataSource = self.originFileArray.mutableCopy;
    [self.tabvlew reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KsFileViewCell *cell = (KsFileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (cell == nil) {
        cell = [[KsFileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
    }
    KsFileObjModel *actualFile = [_dataSource objectAtIndex:indexPath.row];
    cell.model = actualFile;
    __weak typeof(self) weakSelf = self;
    //设置cell的选中事件
    cell.Clickblock = ^(KsFileObjModel *model,UIButton *btn){
        if (weakSelf.selectedItems.count>=5 && btn.selected) {
            btn.selected =  NO;
            model.select = btn.selected;
            [weakSelf.view makeToast:@"最多支持5个文件选择" duration:0.5 position:CSToastPositionCenter];
            return ;
        }
        if ([weakSelf checkFileSize:model]) {
            if (btn.isSelected) {
                [weakSelf.selectedItems addObject:model];
                weakSelf.assetGridToolBar.selectedItems = weakSelf.selectedItems;
            }else{
                [weakSelf.selectedItems removeObject:model];
                weakSelf.assetGridToolBar.selectedItems = weakSelf.selectedItems;
            }
        }else{
            [weakSelf.view makeToast:@"暂时不支持超过5MB的文件" duration:0.5 position:CSToastPositionCenter];
            btn.selected =  NO;
            model.select = btn.selected;
        }
    };
    return cell;
}

#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    KsFileObjModel *actualFile = [_dataSource objectAtIndex:indexPath.row];
    NSString *cachePath =actualFile.filePath;
    NSLog(@"调用文件查看控制器%@---type %zd, %@",actualFile.name,actualFile.fileType,cachePath);
    KsFlieLookUpVC *vc = [[KsFlieLookUpVC alloc] initWithFileModel:actualFile];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --KsDepartmentViewDelegate
//根据点击进行数据过滤
- (void)didScrollToIndex:(NSInteger)index{
    [self setOrigArray];
    switch (index) {
        case 0:
        {
            self.dataSource = self.originFileArray.mutableCopy;
            [self.dataSource enumerateObjectsUsingBlock:^(KsFileObjModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {

            }];
            [self.tabvlew reloadData];
            
        }
            break;
        case 1:
        {
            NSLog(@"btn.tag%zd",index);
            [self.dataSource removeAllObjects];
            for (KsFileObjModel * model in self.originFileArray) {
                if (model.fileType == MKFileTypeAudioVidio) {
                    [self.dataSource addObject:model];
                }
            }
            [self.tabvlew reloadData];
        }
            break;
        case 2:
        {
            NSLog(@"btn.tag%zd",index);
            [self.dataSource removeAllObjects];
            for (KsFileObjModel * model in self.originFileArray) {
                if (model.fileType == MKFileTypeTxt) {
                    [self.dataSource addObject:model];
                }
            }
            [self.tabvlew reloadData];
        }
            break;
        case 3:
        {
            NSLog(@"btn.tag%zd",index);
            [self.dataSource removeAllObjects];
            for (KsFileObjModel * model in self.originFileArray) {
                if (model.fileType == MKFileTypeApplication) {
                    [self.dataSource addObject:model];
                }
            }
            [self.tabvlew reloadData];
        }
            break;
        case 4:
        {
            NSLog(@"btn.tag%zd",index);
            [self.dataSource removeAllObjects];
            for (KsFileObjModel * model in self.originFileArray) {
                if (model.fileType == MKFileTypeUnknown) {
                    [self.dataSource addObject:model];
                }
            }
            [self.tabvlew reloadData];
            
        }break;
        default:
            NSLog(@"btn.tag%zd",index);
            break;
    }
}
//将已经记录选中的文件，保存
- (void)setOrigArray{
    for (KsFileObjModel *model  in self.selectedItems) {
        [self.originFileArray enumerateObjectsUsingBlock:^(KsFileObjModel *origModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([origModel.filePath isEqualToString:model.filePath]) {
                origModel.select = model.select;
                NSLog(@"被选中的item 是：%@",origModel.filePath);
            }
        }];
    }
}

#pragma mark --KsInternalAssetGridToolBarDelegate
- (void)didClickSenderButtonInAssetGridToolBar:(KsFileManagerToolBar *)internalAssetGridToolBar
{
    
    NSLog(@" 发送文件 ----%@",self.selectedItems);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.fileSelectVcDelegate respondsToSelector:@selector(fileViewControlerSelected:)]) {
        [self.fileSelectVcDelegate fileViewControlerSelected:self.selectedItems];
    }
}



+ (void)getHomeFilePath
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:HomeFilePath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:HomeFilePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
}

/**
 检查文件的大小
 */
- (BOOL )checkFileSize:(KsFileObjModel *)model
{
    if (model.fileSizefloat >= FileMaxSize ) {
        return NO;
    }
    return YES;
}
@end
