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
#import "GZMemberModel.h"
#import "GZHelper.h"

#import "UIImageView+WebCache.h"


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
    
    self.titleLable.text = model.title;
    
    // 头像
    self.avatar.layer.cornerRadius = 3;
    self.avatar.layer.masksToBounds = YES;
    NSString *avatar = [[_model valueForKey:@"member"] valueForKey:@"avatar_mini"];
    NSLog(@"%@", avatar); // 为什么这里写法这么怪...按道理可以 model. 的啊
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", avatar]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    // 时间戳 + 回复数
    NSString *createdTimeStr = [GZHelper timeRemainDescriptionWithDateSP:_model.created];
    NSString *replyCountStr = [NSString stringWithFormat:@"%@ 回复", _model.replies];
    UIFont *timeFont = [UIFont systemFontOfSize:13];
    self.createdAndReply.font = timeFont;
    self.createdAndReply.numberOfLines = 0;
    self.createdAndReply.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.createdAndReply.text = [NSString stringWithFormat:@"%@/%@", createdTimeStr, replyCountStr];
    
    // 用户名
    NSString *userNameStr = _model.member.username;
    self.userName.text = userNameStr;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//}

@end
