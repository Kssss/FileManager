//
//  ViewController.m
//  fileManage
//
//  Created by Vieene on 2016/10/13.
//  Copyright © 2016年 Vieene. All rights reserved.
//

//文件默认存储的路径
//#define HomeFilePath    （[NSString stringWithFormat:@"%@/FilePath", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]])

#define HomeFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CJFileCache1"]

///屏幕高度/宽度
#define CJScreenWidth        [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight       [UIScreen mainScreen].bounds.size.height
#import "CJFileManagerVC.h"
//#import "CJSession.h"
#import "CJFileObjModel.h"
#import "VeFileViewCell.h"
#import "VeFileManagerToolBar.h"
#import "VeFileDepartmentView.h"
#import "CJFlieLookUpVC.h"
#import "UIView+CJToast.h"

CGFloat departmentH = 48;
CGFloat departmentY = 0;
CGFloat toolBarHeight = 49;

@interface CJFileManagerVC ()<UITableViewDelegate,UITableViewDataSource,TYHInternalAssetGridToolBarDelegate,CJDepartmentViewDelegate>
@property (strong, nonatomic) VeFileDepartmentView *departmentView;
@property (strong, nonatomic) VeFileManagerToolBar *assetGridToolBar;
@property (strong, nonatomic) NSMutableArray *selectedItems;//记录选中的cell的模型
@property (nonatomic,strong) UITableView *tabvlew;
@property (nonatomic,strong) NSMutableArray *fileList;
@property (nonatomic,strong) NSMutableArray *allfileArray;
@property (nonatomic,strong) UIDocumentInteractionController *documentInteraction;
@property (nonatomic,strong) NSArray *depatmentArray;
@end

@implementation CJFileManagerVC
+ (void)initialize
{
    [self getHomeFilePath];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---%@",HomeFilePath);
    self.title = (@"我的文件");
    self.view.backgroundColor = [UIColor whiteColor];
    [self setClickPartmentView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self loadData];
    [self tabvlew];
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
        CGRect frame = CGRectMake(0,departmentY + departmentH + 10 + 64, CJScreenWidth, CJScreenHeight - departmentY - toolBarHeight - departmentH - 10);
        _tabvlew = [[UITableView alloc]   initWithFrame:frame style:UITableViewStylePlain];
        _tabvlew.tableFooterView = [[UIView alloc] init];
        _tabvlew.delegate = self;
        _tabvlew.dataSource = self;
        _tabvlew.bounces = NO;
        [self.view addSubview:self.tabvlew];

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
        CGRect frame = CGRectMake(0, departmentY + 64, CJScreenWidth, departmentH);
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
    self.view.backgroundColor = [UIColor whiteColor];
    //默认加入几个文件
    NSString *path1 = [[NSBundle mainBundle] pathForResource:@"宋冬野 - 董小姐" ofType:@"mp3"];
    NSString *path2 = [[NSBundle mainBundle] pathForResource:@"IMG_4143" ofType:@"PNG"];
    NSString *path3 = [[NSBundle mainBundle] pathForResource:@"angle" ofType:@"jpg"];
    NSString *path4 = [[NSBundle mainBundle] pathForResource:@"he is a pirate" ofType:@"mp3"];

    CJFileObjModel *mode1 = [[CJFileObjModel alloc] initWithFilePath:path1];
    CJFileObjModel *mode2 = [[CJFileObjModel alloc] initWithFilePath:path2];
    CJFileObjModel *mode3 = [[CJFileObjModel alloc] initWithFilePath:path3];
    CJFileObjModel *mode4 = [[CJFileObjModel alloc] initWithFilePath:path4];

    [self.allfileArray addObjectsFromArray:@[mode1,mode2,mode3,mode4]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray<NSString *> *subPathsArray = [fileManager contentsOfDirectoryAtPath:HomeFilePath error: NULL];
    for(NSString *str in subPathsArray){
        CJFileObjModel *object = [[CJFileObjModel alloc] initWithFilePath: [NSString stringWithFormat:@"%@/%@",HomeFilePath, str]];
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
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VeFileViewCell *cell = (VeFileViewCell *)[tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    if (cell == nil) {
         cell = [[VeFileViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
    }
    CJFileObjModel *actualFile = [_fileList objectAtIndex:indexPath.row];
    cell.model = actualFile;
    __weak typeof(self) weakSelf = self;
    cell.Clickblock = ^(CJFileObjModel *model,UIButton *btn){
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
    
    CJFileObjModel *actualFile = [_fileList objectAtIndex:indexPath.row];
    NSString *cachePath =actualFile.filePath;
    NSLog(@"调用文件查看控制器%@---type %zd, %@",actualFile.name,actualFile.fileType,cachePath);
    CJFlieLookUpVC *vc = [[CJFlieLookUpVC alloc] initWithFileModel:actualFile];
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
                [self.fileList enumerateObjectsUsingBlock:^(CJFileObjModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSLog(@"obj----%zd",self.fileList);
                }];
                [self.tabvlew reloadData];
                
            }
                break;
            case 1:
            {
                NSLog(@"btn.tag%zd",index);
                [self.fileList removeAllObjects];
                for (CJFileObjModel * model in self.allfileArray) {
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
                for (CJFileObjModel * model in self.allfileArray) {
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
                for (CJFileObjModel * model in self.allfileArray) {
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
                for (CJFileObjModel * model in self.allfileArray) {
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
    for (CJFileObjModel *model  in self.selectedItems) {
        [self.allfileArray enumerateObjectsUsingBlock:^(CJFileObjModel *origModel, NSUInteger idx, BOOL * _Nonnull stop) {
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
- (BOOL )checkFileSize:(CJFileObjModel *)model
{
    if (model.fileSizefloat >= 5000000) {
        return NO;
    }
    return YES;
}
@end
