//
//  AppDelegate.m
//  GZv2ex
//
//  Created by Danny Ho on 9/1/16.
//  Copyright © 2016 thanksdanny. All rights reserved.
//

#import "AppDelegate.h"

#import "GZTopicListViewController.h"
#import "GZLeftMenuViewController.h"

#import "MMDrawerController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 中间控制器
    GZTopicListViewController *homeVC = [[GZTopicListViewController alloc] init];
    // 左控制器
    GZLeftMenuViewController *leftVC = [[GZLeftMenuViewController alloc] init];
    // 导航栏
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    UINavigationBar *appearance = [UINavigationBar appearance];
    [appearance setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [appearance setShadowImage:[[UIImage alloc] init]];
    [appearance setBarStyle:UIBarStyleBlackOpaque];
    [appearance setBarTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    [appearance setTintColor:[UIColor whiteColor]];
    [appearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:15], NSFontAttributeName, nil]];
    
    // drawer控制器
    MMDrawerController *drawerVC = [[MMDrawerController alloc] initWithCenterViewController:navVC leftDrawerViewController:leftVC];
    [drawerVC setMaximumLeftDrawerWidth:90.0];
    [drawerVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:drawerVC.view];
    self.window.rootViewController = drawerVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
