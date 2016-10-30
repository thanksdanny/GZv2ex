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
#import <Masonry.h>

static CGFloat const kTitleFontSize         = 17.0f;
static CGFloat const kBottomFontSize        = 12.0f;

@interface GZReplyCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *replyContentLabel;

@end

@implementation GZReplyCell


#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = NSUnderlineStyleNone;
        
        [self configureViews];
    }
    
    return self;
}

#pragma mark - configure views

- (void)configureViews {
    
    __weak UIView *superview = self;
    
    // avatar
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.avatarImageView];
    
    

    // nameLabel
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:kBottomFontSize];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.nameLabel];
    
    
    
    // timeLabel
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:kBottomFontSize];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.timeLabel.alpha = 1.0;
    [self addSubview:self.timeLabel];
    
    
    // replyContentLabel
    self.replyContentLabel = [[UILabel alloc] init];
    self.replyContentLabel.font = [UIFont systemFontOfSize:14];
    self.replyContentLabel.numberOfLines = 0;
    self.replyContentLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.replyContentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.replyContentLabel];

    
    /* ---------- 约束 ---------- */
    // 头像
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@30);
        make.top.and.left.equalTo(superview).with.offset(8);
    }];
    
    // 用户名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(superview).with.offset(8);
        make.left.equalTo(_avatarImageView.mas_right).with.offset(8);
    }];
    
    // 时间戳
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(_nameLabel);
        make.right.equalTo(superview).with.offset(-8);
        
    }];
    
    // 回复内容
    [self.replyContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(8);
        make.left.equalTo(_avatarImageView.mas_right).with.offset(8);
        make.right.equalTo(superview).with.offset(-8);
        make.bottom.equalTo(superview).with.offset(-8);
    }];
    
}

#pragma mark - Data Methods

- (void)setModel:(GZReplyModel *)model {
    _model = model;
    
    // 用户名
    self.nameLabel.text = [NSString stringWithFormat:@"@%@", model.member.memberUsername];
    
    // 头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", model.member.memberAvatarMini]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    // 回复内容
    self.replyContentLabel.text = model.content;
    
    // 回复时间戳
    self.timeLabel.text = [GZHelper timeRemainDescriptionWithDateSP:model.created];
    
}

@end
