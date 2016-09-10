//
//  GZDetailTopicViewController.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GZTopicModel;

@interface GZDetailTopicViewController : UIViewController

@property (nonatomic, strong) GZTopicModel *info;
@property (nonatomic, strong) UITableView *tableView;


@end

