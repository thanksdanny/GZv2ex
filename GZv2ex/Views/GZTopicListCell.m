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
#import <Masonry.h>

static CGFloat const kAvatarHeight          = 26.0f;
static CGFloat const kTitleFontSize         = 17.0f;
static CGFloat const kBottomFontSize        = 12.0f;

#define kTitleLabelWidth ([UIScreen mainScreen].bounds.size.width - 56)

@interface GZTopicListCell ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *replyCountLabel;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *nodeLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *borderLineView;

@property (nonatomic, assign) NSInteger titleHeight;




@end


@implementation GZTopicListCell

#pragma mark - init

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self configureViews];
    }
    
    return self;
}
//
//#pragma mark - layout
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.avatarImageView.frame  = (CGRect){[UIScreen mainScreen].bounds.size.width - 10 - kAvatarHeight, 13, kAvatarHeight, kAvatarHeight};
//    self.titleLabel.frame       = CGRectMake(10, 15, kTitleLabelWidth, self.titleHeight);
//    
//}

#pragma mark - configure views

- (void)configureViews {
    // avatar
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.clipsToBounds      = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.avatarImageView];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.contentView).offset(8);
//        make.height.mas_equalTo(40);
//        make.width.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];

    // name
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:kBottomFontSize];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.nameLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    // time
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:kBottomFontSize];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    self.timeLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.timeLabel.alpha = 1.0;
    [self addSubview:self.timeLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(1);
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByCharWrapping;
    [self addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_bottom).offset(1);
        make.left.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
        make.size.mas_equalTo(CGSizeMake(343, 30));
    }];
    
    // reply
    self.replyCountLabel = [[UILabel alloc] init];
    self.replyCountLabel.backgroundColor = [UIColor clearColor];
    self.replyCountLabel.textColor = [UIColor whiteColor];
    self.replyCountLabel.font = [UIFont systemFontOfSize:8];
    self.replyCountLabel.textAlignment = NSTextAlignmentCenter;
    self.replyCountLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    [self addSubview:self.replyCountLabel];
    
    // node
    self.nodeLabel = [[UILabel alloc] init];
    self.nodeLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.040];
    self.nodeLabel.font = [UIFont systemFontOfSize:kBottomFontSize];
    self.nodeLabel.textAlignment = NSTextAlignmentLeft;
    self.nodeLabel.textColor = [UIColor blackColor];
    self.nodeLabel.lineBreakMode = NSLineBreakByTruncatingTail; // 文字截断方式
    [self addSubview:self.nodeLabel];
    [self.nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(1);
        make.left.equalTo(self.contentView).offset(8);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    // 顶线
    self.topLineView = [[UIView alloc] init];
    [self addSubview:self.topLineView];
    
    // 底线
    self.borderLineView = [[UIView alloc] init];
    [self addSubview:self.borderLineView];
    
    // 各个label字体颜色
//    self.titleLabel.textColor               = kFontColorBlackDark;
//    self.timeLabel.textColor                = kFontColorBlackLight;
//    self.nameLabel.textColor                = kFontColorBlackBlue;
//    self.nodeLabel.textColor                = kFontColorBlackLight;
//    self.topLineView.backgroundColor        = kLineColorBlackDark;
//    self.borderLineView.backgroundColor     = kLineColorBlackDark;
}

#pragma mark - Data Methods

- (void)setModel:(GZTopicModel *)model {
    _model = model;
    NSLog(@"%@", model);
    
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.titleLabel.text = model.topicTitle;
    
    // 头像
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", model.topicMember.memberAvatarMini]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    // 时间戳
    NSString *timestamp = [GZHelper timeRemainDescriptionWithDateSP:model.topicCreated];
    self.timeLabel.text = [NSString stringWithFormat:@"%@", timestamp];
    
    // 回复数
    NSString *replyCountStr = [NSString stringWithFormat:@"%@ 回复", model.topicReplies];
    self.replyCountLabel.text = [NSString stringWithFormat:@"%@", replyCountStr];
    
    // 用户名
    NSString *userNameStr = model.topicMember.memberUsername;
    self.nameLabel.text = userNameStr;
    
    // 节点
    self.nodeLabel.text =  model.topicNode.nodeName;
}



#pragma mark - Class Methods

+ (CGFloat)getCellHeightWithTopicModel:(GZTopicModel *)model {
    if (model.cellHeight > 10) {
        NSLog(@"cellHeight > 10=================================");
        return model.cellHeight ;
    } else {
        NSLog(@"cellHeight < 10==================================");
        return [self heightWithTopicModel:model];
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
