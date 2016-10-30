//
//  GZTopicListViewController.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZTopicListViewController.h"
#import "GZDetailTopicViewController.h"
#import "GZTopicListCell.h"
#import "GZDataManager.h"
#import "GZTopicModel.h"
#import "MJRefresh.h"

#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"

@interface GZTopicListViewController () <UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, strong) NSArray *topicList;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GZTopicListCell *cell;


@end

@implementation GZTopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最热";
    
    [self updateHotData];
    [self configureRefresh];
    [self initHeaderButton];
    
}

#pragma mark - init view

- (void)initHeaderButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 14)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_menu_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

#pragma mark - Configure

- (void)configureRefresh {
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
        [self updateHotData];
        
        [self.tableView.mj_header endRefreshing];
    }];
    
    
    // 设置自动切换透明度（在导航栏下面自动隐藏）
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self updateHotData];
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Data

- (void)updateHotData {
    // 首页获取数据
    
    [[GZDataManager shareManager] getLatestTopicsSuccess:^(NSArray *latestArray) {
        self.topicList = latestArray;
        [self.tableView reloadData]; // 读完数据需要reloadData
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark - segue

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"TODETAIL"]) {
//        GZDetailTopicViewController *detailVC = [segue destinationViewController];
//        
//        NSLog(@"%@",[self.topicList[self.tableView.indexPathForSelectedRow.row] class]);
//        // 传选中的model过去
//        detailVC.info = self.topicList[self.tableView.indexPathForSelectedRow.row];
//    }
//}

#pragma mark - Table view delagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicList.count;
}

// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightOfTopicCellForIndexPath:indexPath];
    
}

// 设置tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    self.cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!_cell) {
        self.cell = [[GZTopicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureTopicCellWithCell:self.cell IndexPath:indexPath];
}

// 跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GZDetailTopicViewController *detailVC = [[GZDetailTopicViewController alloc] init];
    detailVC.info = self.topicList[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark - Configure TableCell

- (CGFloat)heightOfTopicCellForIndexPath:(NSIndexPath *)indexPath {
    GZTopicModel *model = self.topicList[indexPath.row];
    
    return [GZTopicListCell getCellHeightWithTopicModel:model];
}

- (GZTopicListCell *)configureTopicCellWithCell:(GZTopicListCell *)cell IndexPath:(NSIndexPath *)indexpath {
    
    GZTopicModel *model = self.topicList[indexpath.row];
    
    cell.model = model;
    
    return cell;
}

#pragma mark - 抽屉效果
- (void)leftDrawerButtonPress:(id)sender {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

@end
