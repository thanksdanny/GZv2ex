//
//  GZMenuHeaderView.m
//  GZv2ex
//
//  Created by Danny Ho on 31/10/2016.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "GZMenuHeaderView.h"
#import <Masonry.h>

@interface GZMenuHeaderView ()

@property (nonatomic, strong) UILabel *nodeLabel;

@end

@implementation GZMenuHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = YES;
        [self configureUI];
    }
    
    return self;
}

#pragma mark - configureUI

- (void)configureUI {
    
    __weak UIView *superview = self;
    
    self.nodeLabel = [[UILabel alloc] init];
    _nodeLabel.font = [UIFont systemFontOfSize:20];
    _nodeLabel.textColor = [UIColor whiteColor];
    _nodeLabel.backgroundColor = [UIColor redColor];
    _nodeLabel.text = @"节点：";
    [self addSubview:_nodeLabel];
    
    [_nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.and.height.equalTo(@60);
//        make.left.and.top.equalTo(superview).with.offset(8);
        make.left.and.top.equalTo(superview);
        make.right.and.bottom.equalTo(superview);
    }];
    
    
}

@end
