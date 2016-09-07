//
//  GZTopicListCell.h
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GZTopicModel.h"

@interface GZTopicListCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *titleLable;
//@property (weak, nonatomic) IBOutlet UILabel *userName;
//@property (weak, nonatomic) IBOutlet UILabel *createdAndReply;
//@property (weak, nonatomic) IBOutlet UIImageView *avatar;
//@property (weak, nonatomic) IBOutlet UILabel *nodeLabel;




@property (nonatomic, strong) GZTopicModel *model;

+ (CGFloat)getCellHeightWithTopicModel:(GZTopicModel *)model;
+ (CGFloat)heightWithTopicModel:(GZTopicModel *)model;


@end
