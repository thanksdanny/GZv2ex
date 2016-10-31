//
//  GZLeftMenuViewController.h
//  GZv2ex
//
//  Created by Danny Ho on 9/6/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol nodeSelectDelegate <NSObject>

- (void)nodeSelectAtIndex:(NSString *)code name:(NSString *)name index:(NSInteger)index;

@end

@interface GZLeftMenuViewController : UITableViewController

@property (nonatomic, assign) id<nodeSelectDelegate> delegate;

@end
