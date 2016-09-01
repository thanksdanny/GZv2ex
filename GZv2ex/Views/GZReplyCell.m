//
//  GZReplyCell.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZReplyCell.h"
#import "GZMemberModel.h"
#import "GZHelper.h"

#import "UIImageView+WebCache.h"

@interface GZReplyCell ()

@end

@implementation GZReplyCell


//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//
//}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    /*
     所以建议在awakeFromNib方法中进行初始化的额外操作。因为awakeFromNib是在初始化完成后调用，所以在这个方法里面访问属性（IBOutlet）就可以保证不为nil。
     */
    
}


#pragma mark - Data Methods

- (void)setModel:(GZReplyModel *)model {
    _model = model;
    self.userName.text = [model.member valueForKey:@"username"];
    
    // 头像
    self.avatar.layer.cornerRadius = 3;
    self.avatar.layer.masksToBounds = YES;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", [_model.member valueForKey:@"avatar_mini"]]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    // 回复内容
    self.replyContentLabel.font = [UIFont systemFontOfSize:14];
    self.replyContentLabel.text = _model.content;
    self.replyContentLabel.numberOfLines = 0;
    self.replyContentLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    
    // 回复时间戳
    NSString *createdTimeStr = [GZHelper timeRemainDescriptionWithDateSP:_model.created];
    UIFont *timeFont = [UIFont systemFontOfSize:13];
    self.createdDate.font = timeFont;
    self.createdDate.numberOfLines = 0;
    self.createdDate.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.createdDate.text = createdTimeStr;
    
}

@end
