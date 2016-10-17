//
//  ViewController.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

//文件默认存储的路径
#define HomeFilePath ([NSString stringWithFormat:@"%@", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]])

///屏幕高度/宽度
#define CJScreenWidth        [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight       [UIScreen mainScreen].bounds.size.height
#import "VeFileManagerVC.h"
//#import "TYHlabelView.h"
#import "VeFileObjModel.h"
#import "VeFileViewCell.h"
#import "VeFileManagerToolBar.h"
#import "VeFileDepartmentView.h"
#import "VeFlieLookUpVC.h"
CGFloat departmentH = 48;
CGFloat departmentY = 64;
CGFloat toolBarHeight = 64;

@interface VeFileManagerVC ()<UITableViewDelegate,UITableViewDataSource,TYHInternalAssetGridToolBarDelegate,CJDepartmentViewDelegate>
@property (strong, nonatomic) VeFileDepartmentView *departmentView;
@property (strong, nonatomic) VeFileManagerToolBar *assetGridToolBar;
@property (strong, nonatomic) NSMutableArray *selectedItems;//记录选中的cell的模型
@property (nonatomic,strong) UITableView *tabvlew;
@property (nonatomic,strong) NSMutableArray *fileList;
@property (nonatomic,strong) NSMutableArray *allfileArray;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteraction;
@property (nonatomic,strong) NSArray *depatmentArray;
@end

@implementation VeFileManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---%@",HomeFilePath);
    self.title = @"我的文件";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setClickPartmentView];
    
    [self.view addSubview:self.tabvlew];
    [self loadData];
    [self setupToolbar];
}
- (NSArray *)depatmentArray
{
    if (_depatmentArray == nil) {
        _depatmentArray = @[@"全部",@"音乐",@"文档",@"应用",@"其他"];
        
    }
     return  _depatmentArray;
}
- (UITableView *)tabvlew
{
    if (_tabvlew == nil) {
        CGRect frame = CGRectMake(0,departmentY + departmentH, CJScreenWidth, CJScreenHeight - departmentY - toolBarHeight - departmentH);
        _tabvlew = [[UITableView alloc]   initWithFrame:frame style:UITableViewStylePlain];
        _tabvlew.tableFooterView = [[UIView alloc] init];
        _tabvlew.delegate = self;
        _tabvlew.dataSource = self;
        _tabvlew.bounces = NO;
    }
    return _tabvlew;
}
- (void)setupToolbar
{
    VeFileManagerToolBar *toolbar = [[VeFileManagerToolBar alloc] initWithFrame:CGRectMake(0, CJScreenHeight - toolBarHeight, CJScreenWidth, toolBarHeight)];
    toolbar.delegate = self;
    _assetGridToolBar = toolbar;
    _assetGridToolBar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_assetGridToolBar];
}
- (void)setClickPartmentView
{
    
    [self departmentView];
}
- (NSMutableArray *)selectedItems
{
    if (!_selectedItems) {
        _selectedItems = @[].mutableCopy;
    }
    return _selectedItems;
}

- (VeFileDepartmentView *)departmentView
{
    if (_departmentView == nil) {
        CGRect frame = CGRectMake(0, departmentY, CJScreenWidth, departmentH);
        _departmentView = [[VeFileDepartmentView alloc] initWithParts:self.depatmentArray withFrame:frame];
        _departmentView.cj_delegate = self;
        [self.view addSubview:_departmentView];
    }
    return _departmentView;
}
#pragma mark - loadData
- (void)loadData{
    [_fileList removeAllObjects];
    self.allfileArray = @[].mutableCopy;
    //默认加载2个pdf文件
//    NSString * filePathStr1 = [[NSBundle mainBundle] pathForResource:@"object" ofType:@"pdf"];
    NSString * filePathStr2 = [[NSBundle mainBundle] pathForResource:@"555" ofType:@"xxx"];
    NSString * filePathStr3 = [[NSBundle mainBundle] pathForResource:@"11" ofType:@"docx"];
//    VeFileObjModel *object1 = [[VeFileObjModel alloc] initWithFilePath: filePathStr1];
    VeFileObjModel *object2 = [[VeFileObjModel alloc] initWithFilePath: filePathStr2];
    VeFileObjModel *object3 = [[VeFileObjModel alloc] initWithFilePath: filePathStr3];
    [self.allfileArray addObjectsFromArray:@[object2,object3]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath:HomeFilePath error: NULL];
    for(NSString *str in subPathsArray){
        NSLog(@"str--%@",str);
        VeFileObjModel *object = [[VeFileObjModel alloc] initWithFilePath: [NSString stringWithFormat:@"%@/%@",HomeFilePath, str]];
        [self.allfileArray addObject: object];
    }
    self.fileList = self.allfileArray.mutableCopy;
    [self.tabvlew reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_fileList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VeFileViewCell *cell = (VeFileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (cell == nil) {
         cell = [[VeFileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
    }
    VeFileObjModel *actualFile = [_fileList objectAtIndex:indexPath.row];
    cell.model = actualFile;
    cell.Clickblock = ^(VeFileObjModel *model,BOOL select){
        if (select) {
            [self.selectedItems addObject:model];
            _assetGridToolBar.selectedItems = _selectedItems;
        }else{
            [self.selectedItems removeObject:model];
            _assetGridToolBar.selectedItems = _selectedItems;

        }
    };
    return cell;
}
#pragma mark -UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VeFileObjModel *actualFile = [_fileList objectAtIndex:indexPath.row];
    NSString *cachePath =actualFile.filePath;
    NSLog(@"调用文件查看控制器%@---type %zd, %@",actualFile.name,actualFile.fileType,cachePath);
    VeFlieLookUpVC *vc = [[VeFlieLookUpVC alloc] initWithFileModel:actualFile];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark --CJDepartmentViewDelegate

- (void)didScrollToIndex:(NSInteger)index{
    [self setOrigArray];
        switch (index) {
            case 0:
            {
                NSLog(@"btn.tag%zd",index);
                self.fileList = self.allfileArray.mutableCopy;
                [self.fileList enumerateObjectsUsingBlock:^(VeFileObjModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"obj----%zd",self.fileList);
                }];
                //清空本地tabbleView的数据源
                [self.tabvlew reloadData];
                
            }
                break;
            case 1:
            {
                NSLog(@"btn.tag%zd",index);
                [self.fileList removeAllObjects];
                for (VeFileObjModel * model in self.allfileArray) {
                if (model.fileType == MKFileTypeAudioVidio) {
                        [self.fileList addObject:model];
                    }
                }
                [self.tabvlew reloadData];
            }
                break;
            case 2:
            {
                NSLog(@"btn.tag%zd",index);
                [self.fileList removeAllObjects];
                for (VeFileObjModel * model in self.allfileArray) {
                    if (model.fileType == MKFileTypeTxt) {
                        [self.fileList addObject:model];
                    }
                }
                [self.tabvlew reloadData];
            }
                break;
            case 3:
            {
                NSLog(@"btn.tag%zd",index);
                [self.fileList removeAllObjects];
                for (VeFileObjModel * model in self.allfileArray) {
                    if (model.fileType == MKFileTypeApplication) {
                        [self.fileList addObject:model];
                    }
                }
                [self.tabvlew reloadData];
            }
                break;
            case 4:
            {
                NSLog(@"btn.tag%zd",index);
                [self.fileList removeAllObjects];
                for (VeFileObjModel * model in self.allfileArray) {
                    if (model.fileType == MKFileTypeUnknown) {
                        [self.fileList addObject:model];
                    }
                }
                [self.tabvlew reloadData];
                
            }break;
            default:
                NSLog(@"btn.tag%zd",index);
                break;
        }
}

- (void)setOrigArray{
    for (VeFileObjModel *model  in self.selectedItems) {
        [self.allfileArray enumerateObjectsUsingBlock:^(VeFileObjModel *origModel, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([origModel.filePath isEqualToString:model.filePath]) {
                origModel.select = model.select;
                NSLog(@"被选中的item 是：%@",origModel.filePath);
            }
        }];
    }
}
#pragma mark --TYHInternalAssetGridToolBarDelegate
- (void)didClickPreviewInAssetGridToolBar:(VeFileManagerToolBar *)internalAssetGridToolBar{
    NSLog(@"----");
}
- (void)didClickSenderButtonInAssetGridToolBar:(VeFileManagerToolBar *)internalAssetGridToolBar
{
    NSLog(@"SenderButtonInAsset----%@",self.selectedItems);
}
@end
