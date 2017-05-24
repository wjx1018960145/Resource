//
//  LeftMenuDelegateImpl.m
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "LeftMenuDelegateImpl.h"


@interface LeftMenuDelegateImpl ()
{
    int selectedIndex;
}
@end



@implementation LeftMenuDelegateImpl

- (void)tableView:(JXTableViewController *)tableView didSelectRowAtIndexPath:(NSInteger)indexPath data:(id)data {
   int _id = [data[@"id"] intValue];
    if (_id == selectedIndex) {
        
    }
    selectedIndex = _id;
    UINavigationController *rootVC = (UINavigationController *)self.slideNav.rootVC;
    
    if (_id == 0) {
        [rootVC popToRootViewControllerAnimated:YES];
        
    }else {
        [rootVC popToRootViewControllerAnimated:YES];
    }
    NSString *title = data[@"name"];
    UIViewController *detailVC;
    if ([data[@"controllerClass"]length]>0) {
        Class c = NSClassFromString(data[@"controllerClass"]);
        if (c) {
            detailVC = [[c alloc] init];
        }
    }
    if ([data[@"controllerNib"] length] > 0) {
        Class c = NSClassFromString(data[@"controllerNib"]);
        if (c) {
            detailVC = [[c alloc] initWithNibName:data[@"controllerNib"] bundle:nil];
        }
    }
    if (detailVC) {
        detailVC.title = title;
        
        [rootVC pushViewController:detailVC animated:YES ];
    }
}


@end
