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

@interface GZTopicListViewController () <UITableViewDelegate, UITableViewDataSource>



@property (nonatomic, strong) NSArray *topicList;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GZTopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最热";
    [self updateHotData];
    [self configureRefresh];
    
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TODETAIL"]) {
        GZDetailTopicViewController *detailVC = [segue destinationViewController];
        
        NSLog(@"%@",[self.topicList[self.tableView.indexPathForSelectedRow.row] class]);
        // 传选中的model过去
        detailVC.info = self.topicList[self.tableView.indexPathForSelectedRow.row];
    }
}

#pragma mark - Table view delagate

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 8;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%ld", self.topicList.count);
    return self.topicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    GZTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GZTopicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureTopicCellWithCell:cell IndexPath:indexPath];
}

#pragma mark - Configure TableCell

- (GZTopicListCell *)configureTopicCellWithCell:(GZTopicListCell *)cell IndexPath:(NSIndexPath *)indexpath {
    
    GZTopicModel *model = self.topicList[indexpath.row];
    
    cell.model = model;
    
    return cell;
}

@end
