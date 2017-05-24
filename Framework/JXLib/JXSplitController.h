//
//  JXSplitController.h
//  Framework
//
//  Created by junxinWang on 15-7-23.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    JXSplitNavigationControllerViewTypeLeft = 0,
    JXSplitNavigationControllerViewTypeRoot,
    JXSplitNavigationControllerViewTypeRight
} JXSplitNavigationControllerViewType;

typedef enum {
    SidePanDirectionNone = 0,
    SidePanDirectionLeft,
    SidePanDirectionRight,
} SidePanDirection;

typedef enum {
    SidePanCompletionLeft = 0,
    SidePanCompletionRight,
    SidePanCompletionRoot,
} SidePanCompletion;

#define kMenuOverlayWidth(val) (self.view.bounds.size.width - val)
#define kMenuBounceOffset 10.0f
#define kMenuBounceDuration .3f
#define kMenuSlideDuration .3f

/**
 *  侧边栏菜单控制器
 */
@interface JXSplitController : UIViewController<UIGestureRecognizerDelegate>

/** 菜单偏移量 */
@property (nonatomic) float offset;
/** 导航按钮名称 */
@property (nonatomic) NSString *navItemTitle;
/** 左侧视图控制器 */
@property (nonatomic) UIViewController *leftVC;
/** 中间视图控制器 */
@property (nonatomic) UIViewController *rootVC;
/** 右侧视图控制器 */
@property (nonatomic) UIViewController *rightVC;
/** 是否开启手势，默认开启 */
@property (nonatomic) BOOL gestureEnable;
@property(nonatomic,readonly) UITapGestureRecognizer *tap;
@property(nonatomic,readonly) UIPanGestureRecognizer *pan;
/**
 *  实例化侧边菜单控制器
 *
 *  @param rootViewController 中间视图
 *
 *  @return HTUISlideNavigationController
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController;
/**
 *  显示视图
 */
- (void)showDetailViewController:(JXSplitNavigationControllerViewType)flag;
@end
