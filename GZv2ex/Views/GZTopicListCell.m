//
//  GZTopicListCell.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZTopicListCell.h"

#import "GZTopicListCell.h"
#import "GZTopicModel.h"
#import "GZNodeModel.h"
#import "GZMemberModel.h"
#import "GZHelper.h"

#import "UIImageView+WebCache.h"

static CGFloat const kAvatarHeight          = 26.0f;
static CGFloat const kTitleFontSize         = 17.0f;
static CGFloat const kBottomFontSize        = 12.0f;

#define kTitleLabelWidth ([UIScreen mainScreen].bounds.size.width - 56)

@interface GZTopicListCell ()

@end


@implementation GZTopicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

#pragma mark - Data Methods

- (void)setModel:(GZTopicModel *)model {
    _model = model;
    NSLog(@"%@", model);
    
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLable.text = model.topicTitle;
    
    // 头像
    self.avatar.layer.cornerRadius = 3;
    self.avatar.layer.masksToBounds = YES;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", model.topicMember.memberAvatarMini]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    // 时间戳 + 回复数
    NSString *createdTimeStr = [GZHelper timeRemainDescriptionWithDateSP:_model.topicCreated];
    NSString *replyCountStr = [NSString stringWithFormat:@"%@ 回复", _model.topicReplies];
    UIFont *timeFont = [UIFont systemFontOfSize:13];
    self.createdAndReply.font = timeFont;
    self.createdAndReply.numberOfLines = 0;
    self.createdAndReply.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.createdAndReply.text = [NSString stringWithFormat:@"%@/%@", createdTimeStr, replyCountStr];
    
    // 用户名
    NSString *userNameStr = _model.topicMember.memberUsername;
    self.userName.text = userNameStr;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//}

#pragma mark - Class Methods

+ (CGFloat)getCellHeightWithTopicModel:(GZTopicModel *)model {
    if (model.cellHeight > 10) {
        return model.cellHeight;
    } else {
        return [self getCellHeightWithTopicModel:model];
    }
}

+ (CGFloat)heightWithTopicModel:(GZTopicModel *)model {
    NSInteger titleHeight = [GZHelper getTextHeightWithText:model.topicTitle Font:[UIFont systemFontOfSize:kTitleFontSize] Width:kTitleLabelWidth] + 1;
    
    NSInteger bottomHeight = (NSInteger)[GZHelper getTextHeightWithText:model.topicNode.nodeName Font:[UIFont systemFontOfSize:kBottomFontSize] Width:CGFLOAT_MAX] + 1;
    
    CGFloat cellHeight = 8 + 13 * 2 + titleHeight + bottomHeight;
    model.cellHeight = cellHeight;
    model.titleHeight = titleHeight;
    
    return cellHeight;
}


@end
