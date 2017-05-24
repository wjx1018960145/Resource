//
//  AppDelegate.m
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "AppDelegate.h"
#import "LeftMenuDelegateImpl.h"
#import "JXTableViewController.h"
#import "JXSplitController.h"
#import "HTSecurity.h"
@interface AppDelegate ()
@property (nonatomic, strong) JXSplitController *side_nav;//侧边栏控制器

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
//    NSString *str = [@"123" desenc];
//    NSLog(@"%@",str);
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *startVC = [story instantiateInitialViewController];
    _side_nav = [[JXSplitController alloc] initWithRootViewController:startVC];
    
    JXTableViewController *leftMenu = [[JXTableViewController alloc] init];
     NSArray *menus = [JXUtil string2json:[NSString stringWithContentsOfFile:[JXUtil pathOfResource:@"menus.geojson"] encoding:NSUTF8StringEncoding error:nil]] ;
    
    LeftMenuDelegateImpl *impl = [[LeftMenuDelegateImpl alloc] init];
    
    impl.slideNav = _side_nav;
    leftMenu.delegate = impl;
    leftMenu.data = menus;
    [_side_nav setLeftVC:leftMenu];
    [self.window setRootViewController:_side_nav];
    [self.window makeKeyAndVisible];
    return YES;
}

- (NSArray *)tableView:(JXTableViewController *)tableView filterText:(NSString *)filterText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name like[cd] '*%@*'", filterText]];
    
    return [tableView.data filteredArrayUsingPredicate:predicate];
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
