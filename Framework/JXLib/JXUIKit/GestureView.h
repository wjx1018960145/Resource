//
//  GestureView.h
//  GestureRecognizerDemo
//
//  Created by Frank on 14/11/2.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GestureView;
@protocol GestureViewDelegate <NSObject, UITableViewDelegate>
- (void)gestureView:(GestureView *)gesture segmentIndex:(NSInteger)segmentIndex;  //处理segmentControl切换事件
- (void)beginButtonTapedInGestureView:(GestureView *)gestureView;// 处理开始动画按钮点击事件
- (void)endButtonTapedInGestureView:(GestureView *)gestureView;//处理结束动画按钮点击事件
@end
@interface GestureView : UIView
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) id<GestureViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items;
@end
