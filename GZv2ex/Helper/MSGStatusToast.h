//
//  MSGStatusToast.h
//  GZv2ex
//
//  Created by Danny Ho on 03/11/2016.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSGStatusToast : UIView

/** 单例对象 */
+ (MSGStatusToast *)shareMSGToast;

/** 显示消息 */
- (void)showMsg:(NSString *)message autoHide:(BOOL)hide;

/** 成功消息 */
- (void)showFinish:(NSString *)message autoHide:(BOOL)hide;

/** 加载错误 */
- (void)showError:(NSString *)message autoHide:(BOOL)hide;

/** 加载中 */
- (void)showLoadAutoHide:(BOOL)hide;

/** 隐藏 */
- (void)hide;

@end
