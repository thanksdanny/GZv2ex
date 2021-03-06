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

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarImageView.frame  = (CGRect){[UIScreen mainScreen].bounds.size.width - 10 - kAvatarHeight, 13, kAvatarHeight, kAvatarHeight};
    self.titleLabel.frame       = CGRectMake(10, 15, kTitleLabelWidth, self.titleHeight);
    
}

#pragma mark - configure views

- (void)configureViews {
    // avatar
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.clipsToBounds      = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.avatarImageView];

    // title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByCharWrapping;
    [self addSubview:self.titleLabel];
    
    // reply
    self.replyCountLabel = [[UILabel alloc] init];
    self.replyCountLabel.backgroundColor = [UIColor clearColor];
    self.replyCountLabel.textColor = [UIColor whiteColor];
    self.replyCountLabel.font = [UIFont systemFontOfSize:8];
    self.replyCountLabel.textAlignment = NSTextAlignmentCenter;
    self.replyCountLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    [self addSubview:self.replyCountLabel];
    
    // time
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.backgroundColor = [UIColor clearColor];
    self.timeLabel.font = [UIFont systemFontOfSize:kBottomFontSize];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.timeLabel.alpha = 1.0;
    [self addSubview:self.timeLabel];

    // name
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:kBottomFontSize];
    self.nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.nameLabel];
    
    // node
    self.nodeLabel = [[UILabel alloc] init];
    self.nodeLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.040];
    self.nodeLabel.font = [UIFont systemFontOfSize:kBottomFontSize];
    self.nodeLabel.textAlignment = NSTextAlignmentCenter;
    self.nodeLabel.lineBreakMode = NSLineBreakByTruncatingTail; // 文字截断方式
    [self addSubview:self.nodeLabel];
    
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
}



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
