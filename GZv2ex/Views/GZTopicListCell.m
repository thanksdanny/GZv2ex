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

//static CGFloat const kAvatarHeight          = 26.0f;
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
@property (nonatomic, strong) UILabel *timeAndReplyCountLabel;

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


#pragma mark - configure views

- (void)configureViews {
    
    __weak UIView *superview = self;
    
    // avatar
    self.avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.avatarImageView.layer.cornerRadius = 3;
    self.avatarImageView.clipsToBounds      = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.avatarImageView];
    

    // name
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.font = [UIFont boldSystemFontOfSize:kBottomFontSize];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.nameLabel];
    
    
    // 时间戳与回复数
    self.timeAndReplyCountLabel = [[UILabel alloc] init];
    self.timeAndReplyCountLabel.backgroundColor = [UIColor clearColor];
    self.timeAndReplyCountLabel.textAlignment = NSTextAlignmentLeft;
    self.timeAndReplyCountLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:90.0/255.0 blue:90.0/255.0 alpha:1];
    self.timeAndReplyCountLabel.alpha = 1.0;
    [self addSubview:self.timeAndReplyCountLabel];
    
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.font = [UIFont systemFontOfSize:kTitleFontSize];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail|NSLineBreakByCharWrapping;
    [self addSubview:self.titleLabel];
    
    
    // node
    self.nodeLabel = [[UILabel alloc] init];
    self.nodeLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.040];
    self.nodeLabel.font = [UIFont systemFontOfSize:kBottomFontSize];
    self.nodeLabel.textAlignment = NSTextAlignmentLeft;
    self.nodeLabel.textColor = [UIColor blackColor];
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
    
    /* ---------- 约束 ---------- */
    // 头像
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).with.offset(8);
        make.left.equalTo(superview).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    // 用户名
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview).offset(8);
        make.left.equalTo(_avatarImageView.mas_right).with.offset(8);
        make.size.mas_equalTo(CGSizeMake(120, 20));
    }];
    
    // 时间戳与回复数
    [self.timeAndReplyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(4);
        make.left.equalTo(_nameLabel);
    }];
    
    // title
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).with.offset(8);
        make.left.equalTo(superview).with.offset(8);
        make.right.equalTo(superview).with.offset(-8);
        make.bottom.equalTo(superview).with.offset(-20);
    }];

    // node
    [self.nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(4);
        make.left.equalTo(superview).with.offset(8);
        make.bottom.equalTo(superview).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
}

#pragma mark - Data Methods

- (void)setModel:(GZTopicModel *)model {
    _model = model;
    
    // title
    self.titleLabel.text = model.topicTitle;
    
    // 头像
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https:%@", model.topicMember.memberAvatarMini]] placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    
    // 时间戳与回复数
    NSString *timestamp = [GZHelper timeRemainDescriptionWithDateSP:model.topicCreated];
    NSString *replyCountStr = [NSString stringWithFormat:@"%@ 回复", model.topicReplies];
    NSString *timeAndReplyCountStr = [NSString stringWithFormat:@"%@/%@ 回复", timestamp, replyCountStr];
    self.timeAndReplyCountLabel.text = timeAndReplyCountStr;
    
    // 用户名
    self.nameLabel.text = model.topicMember.memberUsername;
    
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
