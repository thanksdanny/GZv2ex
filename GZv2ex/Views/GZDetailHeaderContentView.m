//
//  GZDetailHeaderContentView.m
//  GZv2ex
//
//  Created by Danny Ho on 9/10/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZDetailHeaderContentView.h"
#import "GZTopicModel.h"
#import "GZMemberModel.h"
#import "GZReplyModel.h"
#import "GZNodeModel.h"
#import "GZDataManager.h"
#import "GZHelper.h"

#import <Masonry.h>
#import "UIImageView+WebCache.h"

@interface GZDetailHeaderContentView ()

@property (nonatomic, strong) UIImageView *avatarViewImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *replyCountLabel;
@property (nonatomic, strong) UILabel *nodeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tagByLabel;
@property (nonatomic, strong) UILabel *bottomLine;
@property (nonatomic, strong) UILabel *contentLabel;


@end

@implementation GZDetailHeaderContentView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES; // clipsToBounds:如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
        [self configureUI];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withModel:(GZTopicModel *)model {
    self.headerInfo = model;
    
    return [self initWithFrame:frame];
}

#pragma mark - configure


- (void)configureUI {
    
    __weak UIView *superview = self;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.headerInfo.topicTitle;
    [self addSubview:self.titleLabel];
    
    // 头像
    self.avatarViewImage = [[UIImageView alloc] init];
    self.avatarViewImage.backgroundColor = [UIColor blackColor];
    self.avatarViewImage.layer.cornerRadius = 3;
    self.avatarViewImage.layer.masksToBounds = YES;
    [self.avatarViewImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", self.headerInfo.topicMember.memberAvatarMini]]
                  placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [self addSubview:self.avatarViewImage];
    
    
    // "by" 的 tag label
    self.tagByLabel = [[UILabel alloc] init];
    self.tagByLabel.font = [UIFont boldSystemFontOfSize:12];
    self.tagByLabel.textColor = [UIColor grayColor];
    self.tagByLabel.text = [NSString stringWithFormat:@"By"];
    [self addSubview:self.tagByLabel];
    
    
    
    // name
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:12];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", self.headerInfo.topicMember.memberUsername];
    [self addSubview:self.nameLabel];
    
    
    // reply
    self.replyCountLabel = [[UILabel alloc] init];
    self.replyCountLabel.font = [UIFont systemFontOfSize:13];
    self.replyCountLabel.numberOfLines = 0;
    self.replyCountLabel.textColor = [UIColor grayColor];
    self.replyCountLabel.text = [NSString stringWithFormat:@"%@ 回复", self.headerInfo.topicReplies];
    [self addSubview:self.replyCountLabel];

    // node
    self.nodeLabel = [[UILabel alloc] init];
    self.nodeLabel.font = [UIFont systemFontOfSize:13];
    self.nodeLabel.numberOfLines = 0;
    self.nodeLabel.textColor = [UIColor whiteColor];
    self.nodeLabel.backgroundColor = [UIColor lightGrayColor];
    self.nodeLabel.textAlignment = NSTextAlignmentCenter;
    self.nodeLabel.layer.cornerRadius = 3;
    self.nodeLabel.layer.masksToBounds = YES;
    self.nodeLabel.text = self.headerInfo.topicNode.nodeName;
    [self addSubview:self.nodeLabel];
    
    
    // time
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.timeLabel.text = [GZHelper timeRemainDescriptionWithDateSP:self.headerInfo.topicCreated];
    [self addSubview:self.timeLabel];
    
    // bottomline
    self.bottomLine = [[UILabel alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    [self addSubview:self.bottomLine];
    
    // content  -- 多行
    CGFloat preferrredMaxWidth = [UIScreen mainScreen].bounds.size.width - 33 - 4 * 3; // 33 = 头像宽度 4 * 3 为 padding
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = [UIColor grayColor];
    self.contentLabel.text = self.headerInfo.topicContent;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.preferredMaxLayoutWidth = preferrredMaxWidth; // 多行时必须设置
    
    [self addSubview:self.contentLabel];
   
    
    /* ------------- 约束 ------------- */
    
    // titleLabel
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@22);
        make.top.equalTo(superview).with.offset(8);
        make.left.equalTo(superview).with.offset(8);
        make.right.equalTo(_avatarViewImage.mas_left).with.offset(-8);
    }];
    
    // 头像
    [self.avatarViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@40);
        make.right.equalTo(superview).with.offset(-8);
        make.top.equalTo(superview).with.offset(8);
    }];
    
    // by 的 tag Label
    [self.tagByLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.height.equalTo(@20);
        make.top.equalTo(_avatarViewImage.mas_bottom).with.offset(8);
        make.left.equalTo(superview).with.offset(8);
        make.bottom.equalTo(_bottomLine.mas_top).offset(-8);
    }];
    
    // 用户名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.height.equalTo(@20);
        make.top.equalTo(_tagByLabel);
        make.left.equalTo(_tagByLabel.mas_right).with.offset(4);
        make.bottom.equalTo(_tagByLabel);
    }];
    
    // 回复数
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(_tagByLabel);
        make.left.equalTo(_nameLabel.mas_right).with.offset(4);
        make.bottom.equalTo(_tagByLabel);
    }];
    
    // 节点
    [self.nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(_tagByLabel);
        make.left.equalTo(_replyCountLabel.mas_right).with.offset(4);
        make.bottom.equalTo(_tagByLabel);
    }];
    
    // 时间戳
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.top.equalTo(_tagByLabel);
        make.right.equalTo(superview).with.offset(-8);
        make.bottom.equalTo(_tagByLabel);
    }];
    
    // 底线
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.top.equalTo(_tagByLabel.mas_bottom).with.offset(16);
        make.left.equalTo(superview).with.offset(8);
        make.right.equalTo(superview).with.offset(-8);
    }];
    
    // 内容
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomLine.mas_bottom).with.offset(8);
        make.left.equalTo(superview).with.offset(8);
        make.right.and.bottom.equalTo(superview).with.offset(-8);
    }];
    
}


@end
