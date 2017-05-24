//
//  GestureView.m
//  GestureRecognizerDemo
//
//  Created by Frank on 14/11/2.
//  Copyright (c) 2014年 Frank. All rights reserved.
//

#import "GestureView.h"
#define kMargin_Left_SC     10
#define kMargin_Top_SC      66
#define kWidth_SC           300
#define kHeight_SC          30

#define kMargin_Left_IM        70
#define kMargin_Between_SI     40    //segmentedControl与imageView的间距
#define kWidth_IM              180
#define kHeight_IM             300
#define kMargin_Top_IM       (kHeight_SC+kMargin_Top_SC+kMargin_Between_SI)

#define kMargin_Left_Begin     30
#define kHeight_Button         30
#define kWidth_Button          80
#define kMargin_Between_BI     40   //buton与imageView的间距
#define kMargin_Top_Button    (kMargin_Top_IM+kHeight_IM+kMargin_Between_BI)
#define kMargin_Between_BE     100
#define kMargin_Left_End       (kMargin_Left_Begin+kWidth_Button+kMargin_Between_BE)
@implementation GestureView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
       // [self layoutImageView];
        //[self layoutBeginAndEndButton];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray *)items {
    self = [self initWithFrame:frame];
    if (self) {
        [self layoutSegmentedControlWithItems:items];
    }
    return self;
}
#pragma mark - layoutSubviews
//布局segmentedControl
- (void)layoutSegmentedControlWithItems:(NSArray *)items {
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:items];
    segControl.frame = CGRectMake(kMargin_Left_SC, kMargin_Top_SC, kWidth_SC, kHeight_SC);
    [segControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:segControl];
   
    
}
//布局imageView
- (void)layoutImageView {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin_Left_IM, kMargin_Top_IM, kWidth_IM, kHeight_IM)];
    _imageView.userInteractionEnabled = YES;
    _imageView.backgroundColor = [UIColor greenColor];
    [self addSubview:_imageView];
   
}
//布局开始动画以及结束动画按钮
- (void)layoutBeginAndEndButton {
    UIButton *beginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    beginBtn.layer.cornerRadius = 5;
    [beginBtn setTitle:@"开始动画" forState:UIControlStateNormal];
    beginBtn.backgroundColor = [UIColor greenColor];
    beginBtn.frame = CGRectMake(kMargin_Left_Begin, kMargin_Top_Button, kWidth_Button, kHeight_Button);
    [beginBtn addTarget:self action:@selector(handleBegin:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:beginBtn];
    
    UIButton *endBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    endBtn.layer.cornerRadius = 5;
    endBtn.backgroundColor = [UIColor greenColor];
    [endBtn setTitle:@"结束动画" forState:UIControlStateNormal];
    endBtn.frame = CGRectMake(kMargin_Left_End, kMargin_Top_Button, kWidth_Button, kHeight_Button);
    [endBtn addTarget:self action:@selector(handleEnd:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:endBtn];
}

#pragma mark - handle action
//view只负责显示内容 以及 接收触摸事件,但是不处理触摸事件, 所有的触摸事件交由Controller去处理.
//segmentControl触发事件
- (void)handleSegmentedControl:(UISegmentedControl *)segmentedControl {
    if ([self.delegate respondsToSelector:@selector(gestureView:segmentIndex:)]) {
        [self.delegate gestureView:self segmentIndex:segmentedControl.selectedSegmentIndex];
    }
}
//beginBtn触发事件
- (void)handleBegin:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(beginButtonTapedInGestureView:)]) {
        [self.delegate beginButtonTapedInGestureView:self];
    }
}
//endBtn触发事件
- (void)handleEnd:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(endButtonTapedInGestureView:)]) {
        [self.delegate endButtonTapedInGestureView:self];
    }
}
- (void)dealloc {
   
}
@end
