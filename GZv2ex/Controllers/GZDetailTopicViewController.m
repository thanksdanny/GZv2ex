//
//  GZDetailTopicViewController.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZDetailTopicViewController.h"
#import "GZDataManager.h"
#import "GZReplyModel.h"
#import "GZMemberModel.h"
#import "GZTopicModel.h"
#import "GZNodeModel.h"
#import "GZReplyCell.h"
#import "GZDetailHeaderContentView.h"
#import "GZHelper.h"


#import "UIImageView+WebCache.h"

@interface GZDetailTopicViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *replyDataList;
@property (nonatomic, strong) GZDetailHeaderContentView *headerView;
@property (nonatomic) CGFloat cellContentWidth;

@end

@implementation GZDetailTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTable];
    [self configureUI];
    [self initHeaderBackButton];
    [self getTopicData];
    [self getReplyData];
    
}

#pragma mark - init view

- (void)initTable {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.tableView];
    
   
}

- (void)initHeaderBackButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"circle-left"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBackButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBackButton;
    
}
#pragma mark - configure


- (void)configureUI {
    self.cellContentWidth = [UIScreen mainScreen].bounds.size.width - 69;
    
    self.title = @"主题详情";
    

}
#pragma mark - 请求数据

- (void)getTopicData {
    [[GZDataManager shareManager] getTopicWithTopicId:self.info.topicId success:^(GZTopicModel *model) {
        self.headerView = [[GZDetailHeaderContentView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 400) withModel:model];
     
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

- (void)getReplyData {
    // 获取回复详情数据
    [[GZDataManager shareManager] getRepliesWithTopicId:self.info.topicId success:^(NSArray *repliesArray) {
        self.replyDataList = repliesArray;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    GZReplyModel *obj = [self.replyDataList objectAtIndex:indexPath.row];
    UIFont *countFont = [UIFont systemFontOfSize:14];
    CGSize countSize = [obj.content boundingRectWithSize:CGSizeMake(self.cellContentWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:countFont} context:nil].size;
    
    return countSize.height + 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.headerView.frame.size.height;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.replyDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"DetailCellIdentifier";
    GZReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!replyCell) {
        replyCell = [[GZReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureTopicCellWithCell:replyCell IndexPath:indexPath];
}

#pragma mark - Configure TableCell

- (GZReplyCell *)configureTopicCellWithCell:(GZReplyCell *)cell IndexPath:(NSIndexPath *)indexpath {
    
    GZReplyModel *model = self.replyDataList[indexpath.row];
    
    cell.model = model;
    
    return cell;
}

#pragma mark - action

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
