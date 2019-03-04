//
//  MyUIViewController.m
//  FileBrowser
//
//  Created by 谭建中 on 4/3/2019.
//  Copyright © 2019 Vieene. All rights reserved.
//

#import "MyUIViewController.h"
#import "KsFileManagerVC.h"
@interface MyUIViewController ()

@end

@implementation MyUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (IBAction)inspectFileClick:(UIButton *)sender {
    KsFileManagerVC *vc = [[KsFileManagerVC alloc] init];
    [self.navigationController pushViewController:vc animated:vc];
}


@end
