//
//  TDRefreshNormalHeader.m
//  GZv2ex
//
//  Created by Danny Ho on 03/11/2016.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "TDRefreshNormalHeader.h"

@implementation TDRefreshNormalHeader

- (void)prepare {
    [super prepare];
    
    // 自动透明度
    self.automaticallyChangeAlpha = YES;
    
    // 隐藏最后更新时间
    self.lastUpdatedTimeLabel.hidden = NO;
}

@end
