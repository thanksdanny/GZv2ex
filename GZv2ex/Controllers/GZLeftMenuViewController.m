//
//  GZLeftMenuViewController.m
//  GZv2ex
//
//  Created by Danny Ho on 9/6/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZLeftMenuViewController.h"
#import "GZNodeModel.h"
#import "GZMenuHeaderView.h"

NSArray *__nodeArray;

@interface GZLeftMenuViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) GZMenuHeaderView *headerView;

@end

@implementation GZLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initTable];
    [self initHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Data

- (void)initTable {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)initHeaderView {
    self.headerView = [[GZMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, 90, 64)];
}

- (void)initData {
    GZMenuNode *nodeTect = [[GZMenuNode alloc] initWithNodeName:@"技术" nodeCode:@"tect"];
    GZMenuChildNode *tech1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"程序员" childNode:@"programmer"];
    GZMenuChildNode *tech2 = [[GZMenuChildNode alloc] initWithChildNodeName:@"Python" childNode:@"python"];
    GZMenuChildNode *tech3 = [[GZMenuChildNode alloc] initWithChildNodeName:@"iDev" childNode:@"idev"];
    GZMenuChildNode *tech4 = [[GZMenuChildNode alloc] initWithChildNodeName:@"Android" childNode:@"android"];
    GZMenuChildNode *tech5 = [[GZMenuChildNode alloc] initWithChildNodeName:@"Linux" childNode:@"linux"];
    GZMenuChildNode *tech6 = [[GZMenuChildNode alloc] initWithChildNodeName:@"node.js" childNode:@"nodejs"];
    GZMenuChildNode *tech7 = [[GZMenuChildNode alloc] initWithChildNodeName:@"云计算" childNode:@"cloud"];
    GZMenuChildNode *tech8 = [[GZMenuChildNode alloc] initWithChildNodeName:@"宽带症候群" childNode:@"bb"];
    NSArray *techArray = @[tech1, tech2, tech3, tech4, tech5, tech6, tech7, tech8];
    nodeTect.childNodeArray = techArray;
    
    GZMenuNode *nodeCreative = [[GZMenuNode alloc] initWithNodeName:@"创意" nodeCode:@"creative"];
    GZMenuChildNode *creative1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"分享创造" childNode:@"create"];
    GZMenuChildNode *creative2 = [[GZMenuChildNode alloc] initWithChildNodeName:@"设计" childNode:@"design"];
    GZMenuChildNode *creative3 = [[GZMenuChildNode alloc] initWithChildNodeName:@"奇思妙想" childNode:@"idea"];
    NSArray *creativeArray = @[creative1, creative2, creative3];
    nodeCreative.childNodeArray = creativeArray;
    
    GZMenuNode *nodePlay = [[GZMenuNode alloc] initWithNodeName:@"好玩" nodeCode:@"play"];
    GZMenuChildNode *play1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"分享发现" childNode:@"share"];
    GZMenuChildNode *play2 = [[GZMenuChildNode alloc] initWithChildNodeName:@"电子游戏" childNode:@"games"];
    GZMenuChildNode *play3 = [[GZMenuChildNode alloc] initWithChildNodeName:@"电影" childNode:@"movie"];
    GZMenuChildNode *play4 = [[GZMenuChildNode alloc] initWithChildNodeName:@"剧集" childNode:@"tv"];
    GZMenuChildNode *play5 = [[GZMenuChildNode alloc] initWithChildNodeName:@"音乐" childNode:@"music"];
    GZMenuChildNode *play6 = [[GZMenuChildNode alloc] initWithChildNodeName:@"旅游" childNode:@"travel"];
    GZMenuChildNode *play7 = [[GZMenuChildNode alloc] initWithChildNodeName:@"Android" childNode:@"android"];
    GZMenuChildNode *play8 = [[GZMenuChildNode alloc] initWithChildNodeName:@"午夜俱乐部" childNode:@"afterdark"];
    NSArray *playArray = @[play1, play2, play3, play4, play5, play6, play7, play8];
    nodePlay.childNodeArray = playArray;
    
    
    GZMenuNode *nodeApple = [[GZMenuNode alloc] initWithNodeName:@"Apple" nodeCode:@"apple"];
    GZMenuChildNode *apple1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"Mac OS X" childNode:@"macosx"];
    GZMenuChildNode *apple2 = [[GZMenuChildNode alloc] initWithChildNodeName:@"iPhone" childNode:@"iphone"];
    GZMenuChildNode *apple3 = [[GZMenuChildNode alloc] initWithChildNodeName:@"iPad" childNode:@"ipad"];
    GZMenuChildNode *apple4 = [[GZMenuChildNode alloc] initWithChildNodeName:@"MBP" childNode:@"mbp"];
    GZMenuChildNode *apple5 = [[GZMenuChildNode alloc] initWithChildNodeName:@"iMac" childNode:@"imac"];
    GZMenuChildNode *apple6 = [[GZMenuChildNode alloc] initWithChildNodeName:@"Apple" childNode:@"apple"];
    NSArray *appleArray = @[apple1, apple2, apple3, apple4, apple5, apple6];
    nodeApple.childNodeArray = appleArray;
    
    GZMenuNode *nodeJobs = [[GZMenuNode alloc] initWithNodeName:@"酷工作" nodeCode:@"jobs"];
    GZMenuChildNode *jobs1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"酷工作" childNode:@"jobs"];
    GZMenuChildNode *jobs2 = [[GZMenuChildNode alloc] initWithChildNodeName:@"求职" childNode:@"cv"];
    GZMenuChildNode *jobs3 = [[GZMenuChildNode alloc] initWithChildNodeName:@"外包" childNode:@"outsourcing"];
    NSArray *jobsArray = @[jobs1, jobs2, jobs3];
    nodeJobs.childNodeArray = jobsArray;
    
    GZMenuNode *nodeDeals = [[GZMenuNode alloc] initWithNodeName:@"交易" nodeCode:@"deals"];
    GZMenuChildNode *deals1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"二手交易" childNode:@"all4all"];
    GZMenuChildNode *deals2 = [[GZMenuChildNode alloc] initWithChildNodeName:@"物物交换" childNode:@"exchange"];
    GZMenuChildNode *deals3 = [[GZMenuChildNode alloc] initWithChildNodeName:@"免费赠送" childNode:@"free"];
    GZMenuChildNode *deals4 = [[GZMenuChildNode alloc] initWithChildNodeName:@"域名" childNode:@"dn"];
    GZMenuChildNode *deals5 = [[GZMenuChildNode alloc] initWithChildNodeName:@"团购" childNode:@"tuan"];
    NSArray *dealsArray = @[deals1, deals2, deals3, deals4, deals5];
    nodeDeals.childNodeArray = dealsArray;
    
    GZMenuNode *nodeCity = [[GZMenuNode alloc] initWithNodeName:@"城市" nodeCode:@"city"];
    GZMenuChildNode *city1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"北京" childNode:@"beijing"];
    GZMenuChildNode *city2 = [[GZMenuChildNode alloc] initWithChildNodeName:@"上海" childNode:@"shanghai"];
    GZMenuChildNode *city3 = [[GZMenuChildNode alloc] initWithChildNodeName:@"深圳" childNode:@"shenzhen"];
    GZMenuChildNode *city4 = [[GZMenuChildNode alloc] initWithChildNodeName:@"广州" childNode:@"guangzhou"];
    GZMenuChildNode *city5 = [[GZMenuChildNode alloc] initWithChildNodeName:@"杭州" childNode:@"hangzhou"];
    GZMenuChildNode *city6 = [[GZMenuChildNode alloc] initWithChildNodeName:@"成都" childNode:@"chengdu"];
    GZMenuChildNode *city7 = [[GZMenuChildNode alloc] initWithChildNodeName:@"昆明" childNode:@"kunming"];
    GZMenuChildNode *city8 = [[GZMenuChildNode alloc] initWithChildNodeName:@"纽约" childNode:@"nyc"];
    GZMenuChildNode *city9 = [[GZMenuChildNode alloc] initWithChildNodeName:@"洛杉矶" childNode:@"la"];
    NSArray *cityArray = @[city1, city2, city3, city4, city5, city6, city7, city8, city9];
    nodeCity.childNodeArray = cityArray;
    
    GZMenuNode *nodeQna = [[GZMenuNode alloc] initWithNodeName:@"问与答" nodeCode:@"qna"];
    GZMenuChildNode *qna1 = [[GZMenuChildNode alloc] initWithChildNodeName:@"问与答" childNode:@"qna"];
    NSArray *qnaArray = @[qna1];
    nodeQna.childNodeArray = qnaArray;
    
    GZMenuNode *nodeHot = [[GZMenuNode alloc] initWithNodeName:@"最热" nodeCode:@"hot"];
    nodeHot.childNodeArray = [NSArray new];
    
    GZMenuNode *nodeAll = [[GZMenuNode alloc] initWithNodeName:@"全部" nodeCode:@"all"];
    nodeAll.childNodeArray = [NSArray new];
    
    GZMenuNode *nodeR2 = [[GZMenuNode alloc] initWithNodeName:@"R2" nodeCode:@"r2"];
    nodeR2.childNodeArray = [NSArray new];
    
    __nodeArray = @[nodeTect, nodeCreative, nodePlay, nodeApple, nodeJobs, nodeDeals, nodeCity, nodeQna, nodeHot, nodeAll, nodeR2];
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    return _headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return __nodeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GZMenuNode *node = __nodeArray[indexPath.row];
    cell.textLabel.text = node.nodeName;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor blackColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"------------->%@", __nodeArray[indexPath.row]);
}



@end
