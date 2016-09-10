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
@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation GZDetailHeaderContentView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        self.clipsToBounds = YES; // clipsToBounds:如果子视图的范围超出了父视图的边界，那么超出的部分就会被裁剪掉。
        [self configureUI];
    }

    return self;
}

#pragma mark - configure

- (void)configureUI {
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor colorWithRed:79.0/255.0 green:79.0/255.0 blue:79.0/255.0 alpha:1];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.headerInfo.topicTitle;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(8);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 54, 400));
    }];
    
    // avatar
    self.avatarViewImage = [[UIImageView alloc] init];
    self.avatarViewImage.backgroundColor = [UIColor blackColor];
    self.avatarViewImage.layer.cornerRadius = 3;
    self.avatarViewImage.layer.masksToBounds = YES;
    [self.avatarViewImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", self.headerInfo.topicMember.memberAvatarMini]]
                  placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    [self addSubview:self.avatarViewImage];
    
    [self.avatarViewImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self).offset(-38);
        make.top.equalTo(self).offset(8);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    
    // "by" 的 tag label
    self.tagByLabel = [[UILabel alloc] init];
    self.tagByLabel.font = [UIFont boldSystemFontOfSize:12];
    self.tagByLabel.textColor = [UIColor grayColor];
    [self addSubview:self.tagByLabel];
    
    [self.tagByLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.titleLabel.frame.size.height < 17 ? 30 : 17);
        make.left.equalTo(self).offset(8);
        make.size.mas_equalTo(CGSizeMake(20, 30));
    }];
    
    // name
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:12];
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.titleLabel.frame.size.height < 17 ? 30 : 17);
        make.left.equalTo(self.tagByLabel.mas_right).offset(1);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    // reply
    self.replyCountLabel = [[UILabel alloc] init];
    self.replyCountLabel.font = [UIFont systemFontOfSize:13];
    self.replyCountLabel.numberOfLines = 0;
    self.replyCountLabel.textColor = [UIColor grayColor];
    self.replyCountLabel.text = [NSString stringWithFormat:@"%@ 回复", self.headerInfo.topicReplies];
    [self addSubview:self.replyCountLabel];
    
    [self.replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.titleLabel.frame.size.height < 17 ? 30 : 17);
        make.left.equalTo(self.nameLabel.mas_right).offset(1);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    
    
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
    
    [self.nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.titleLabel.frame.size.height < 17 ? 30 : 17);
        make.left.equalTo(self.nameLabel.mas_right).offset(1);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    
    // time
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:13];
    self.timeLabel.numberOfLines = 0;
    self.timeLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.timeLabel.text = [GZHelper timeRemainDescriptionWithDateSP:self.headerInfo.topicCreated];
    [self addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarViewImage.mas_bottom).offset(self.titleLabel.frame.size.height < 17 ? 30 : 17);
        make.right.equalTo(self).offset(-8);
        make.size.mas_equalTo(CGSizeMake(350, 20));
    }];
    
    // bottomline
    self.bottomLine = [[UILabel alloc] init];
    self.bottomLine.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    [self addSubview:self.bottomLine];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tagByLabel.mas_bottom).offset(16);
        make.left.equalTo(self).offset(8);
        make.size.mas_equalTo(CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 16, 0.5));
    }];
    
    
    // content
    self.contentTextView = [[UITextView alloc] init];
    self.contentTextView.font = [UIFont systemFontOfSize:14];
    self.contentTextView.editable = NO;
    self.contentTextView.scrollEnabled = NO;
    self.contentTextView.textColor = [UIColor grayColor];
    self.contentTextView.text = self.headerInfo.topicContent;
    
    
    [self addSubview:self.contentTextView];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(33);
        make.left.equalTo(self).offset(8);
    }];
}

@end
