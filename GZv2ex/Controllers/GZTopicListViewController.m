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
#import "GZNodeModel.h"
#import "GZLeftMenuViewController.h"
#import "TDRefreshNormalHeader.h"
#import "TDRefreshAutoNormalFooter.h"

#import "MMDrawerController.h"
#import "UIViewController+MMDrawerController.h"
#import "MSGStatusToast.h"



@interface GZTopicListViewController () <UITableViewDelegate, UITableViewDataSource, nodeSelectDelegate>

@property (nonatomic, strong) NSArray *topicList;
@property (nonatomic, strong) NSArray *childNodeArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *nodeArray;

@property (nonatomic, strong) UIView *nodeBGView;
@property (nonatomic, strong) UITableView *childNodeTable;
@property (nonatomic, strong) UIButton *childNodeButton;
@property (nonatomic, strong) GZTopicListCell *cell;

@property (nonatomic, assign) CGFloat cellTitleWidth;
@property (nonatomic, assign) Boolean isRequestChildNode;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *fatherNodeCode;
@property (nonatomic, strong) NSString *childNodeCode;
@property (nonatomic, strong) NSString *childNodeName;


@end

@implementation GZTopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRequestChildNode = NO; // 默认刷新的不是子节点
    self.page = 1;
    self.fatherNodeCode = @"all";
    GZLeftMenuViewController *left = (GZLeftMenuViewController *)self.mm_drawerController.leftDrawerViewController;
    left.delegate = self;
    GZMenuNode *node = [_nodeArray objectAtIndex:9]; //默认父节点对象
    self.childNodeArray = node.childNodeArray;
    
    
    [self loadData];
    [self initTable];
    [self initHeaderButton];
    [self initChildNodeButton]; // 导航栏的菜单节点按钮
    
    // 初始化数据对象数组
    self.dataArray = [NSMutableArray array];
    
    // 下拉刷新
    self.tableView.mj_header = [TDRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    // 上拉刷新
    self.tableView.mj_footer = [TDRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    /** 下拉刷新进此方法 */
//    self.refreshHeader = [TDRefreshHeader headerWithRefreshingBlock:^{
//        // 往后加网络状态判断
//        self.page = 1;
//        NSLog(@"ddddddddddddddddd");
//        [self loadData];
//    }];
//    
//    // 开始刷新
//    [_refreshHeader beginRefreshing];
//    
//    /** 上拉刷新 */
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        if (_isRequestChildNode) {
//            self.page += 1;
//            NSLog(@"ddddddddddddddddd");
//            [self loadData];
//        } else {
//            [self.tableView.mj_footer endRefreshing];
//        }
//    }];
    
}

#pragma mark - 下拉刷新

//- (void)configureRefresh {
//    
//    // 下拉刷新
//    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
//        
//        [self loadData];
//        
//        [self.tableView.mj_header endRefreshing];
//    }];
//    
//    
//    // 设置自动切换透明度（在导航栏下面自动隐藏）
//    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    
//    // 上拉刷新
//    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [self loadData];
//        // 结束刷新
//        [self.tableView.mj_footer endRefreshing];
//    }];
//}


- (void)viewWillAppear:(BOOL)animated {
    // 开启左划
    [self.navigationController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

- (void)viewWillDisappear:(BOOL)animated {
    // 禁止左划
    [self.navigationController.mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

#pragma mark - 初始化视图

- (void)initTable {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initHeaderButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 33, 14)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"nav_menu_icon"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftDrawerButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}

- (void)initNodeBGView {
    self.nodeBGView = [[UIView alloc] init];
    self.nodeBGView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    self.nodeBGView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    self.nodeBGView.clipsToBounds = YES;
    [self.view addSubview:_nodeBGView];
    
    self.childNodeTable = [[UITableView alloc] initWithFrame:_nodeBGView.frame style:UITableViewStylePlain];
    self.childNodeTable.delegate = self;
    self.childNodeTable.dataSource = self;
    self.childNodeTable.scrollEnabled = NO;
    self.childNodeTable.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    self.childNodeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [_nodeBGView addSubview:_childNodeTable];
}

- (void)initChildNodeButton {
    self.childNodeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    [self.childNodeButton setTitle:@"全部" forState:UIControlStateNormal];
    [self.childNodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.childNodeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    self.childNodeButton.tag = 0;
    self.navigationItem.titleView = _childNodeButton;
    
    [_childNodeButton addTarget:self action:@selector(childNodeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Data

- (void)loadData {
    // 首页获取数据
    
    [[GZDataManager shareManager] getHotTopicsSuccess:^(NSArray *hotArray) {
        self.topicList = hotArray;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self.tableView.mj_header endRefreshing];
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


#pragma mark - Action
- (void)childNodeButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {
        // 刷新子节点数据
        [_childNodeTable reloadData];
        self.childNodeTable.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), _childNodeArray.count*44);
        [UIView animateWithDuration:0.25 animations:^{
            self.nodeBGView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), _childNodeArray.count*44);
        }];
        sender.tag = 1;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.nodeBGView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0);
        } completion:^(BOOL finished) {
            self.childNodeTable.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 0);
         }];
        sender.tag = 0;
    }
}
@end
