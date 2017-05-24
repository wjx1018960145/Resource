//
//  JXSplitController.m
//  Framework
//
//  Created by junxinWang on 15-7-23.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "JXSplitController.h"

@interface JXSplitController ()

@end

@implementation JXSplitController

{
    JXSplitNavigationControllerViewType c_flag;
    CGFloat _panOriginX;
    CGPoint _panVelocity;
    SidePanDirection panDirection;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        self.rootVC = rootViewController;
        [self self_init];
    }
    return self;
}

- (void)self_init {
    float offset = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 250 : 150;
    _offset = offset;
    _gestureEnable = YES;
    _navItemTitle = @"菜单";
    c_flag = JXSplitNavigationControllerViewTypeRoot;
}
-(void)leftPressed:(id)sender {
    if (c_flag == JXSplitNavigationControllerViewTypeRoot) {
        c_flag = JXSplitNavigationControllerViewTypeLeft;
    } else if (c_flag == JXSplitNavigationControllerViewTypeLeft){
        c_flag = JXSplitNavigationControllerViewTypeRoot;
    }
    [self showViewController];
    
}
- (void)showDetailViewController:(JXSplitNavigationControllerViewType)flag {
    [self showViewController:flag inAnimate:NO];
}

- (void)showViewController {
    [self showViewController:c_flag inAnimate:NO];
}
- (void)showViewController:(BOOL)inAnimate {
    [self showViewController:c_flag inAnimate:inAnimate];
}


- (void)showViewController:(JXSplitNavigationControllerViewType)flag inAnimate:(BOOL)inAnimate {
    c_flag = flag;
    UIViewController *vc;
    float offset = 0;
    switch (c_flag) {
        case JXSplitNavigationControllerViewTypeRoot:
            vc = _rootVC;
            offset = 0;
            break;
        case JXSplitNavigationControllerViewTypeLeft:
            vc = _leftVC;
            offset = _offset;
            break;
        case JXSplitNavigationControllerViewTypeRight:
            vc = _rightVC;
            offset = -_offset;
            break;
    }
    if (vc && vc.view) {
        if (c_flag != JXSplitNavigationControllerViewTypeRoot) {
            [self.view insertSubview:vc.view belowSubview:_rootVC.view];
        }
        if (!inAnimate) {
            CGRect frame = _rootVC.view.frame;
            frame.origin.x = offset;
            NSTimeInterval duration = fabs(_rootVC.view.frame.origin.x - frame.origin.x)/320*0.8;
            
            [UIView animateWithDuration:duration animations:^{
                _rootVC.view.frame = frame;
            } completion:^(BOOL finished) {
            }];
        }
    }
    
}

-(void)rigthPressed:(id)sender {
    if (c_flag == JXSplitNavigationControllerViewTypeRoot) {
        c_flag = JXSplitNavigationControllerViewTypeRight;
    } else if(c_flag == JXSplitNavigationControllerViewTypeRight){
        c_flag = JXSplitNavigationControllerViewTypeRoot;
    }
    [self showViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_leftVC) {
        [self addChildViewController:_leftVC];
        [_leftVC didMoveToParentViewController:self];
        _leftVC.view.frame = CGRectMake(0, 66, self.view.bounds.size.width, self.view.bounds.size.height);
        _leftVC.view.autoresizingMask = 63;
        [self.view addSubview:_leftVC.view];
    }
    if (_rightVC) {
        [self addChildViewController:_rightVC];
        [_rightVC didMoveToParentViewController:self];
        _rightVC.view.frame = CGRectMake(0, 66, self.view.bounds.size.width, self.view.bounds.size.height);
        
        
        _rightVC.view.autoresizingMask = 63;
        [self.view addSubview:_rightVC.view];
        
        //        [_rightVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    if (_rootVC) {
        [self addChildViewController:_rootVC];
        [_rootVC didMoveToParentViewController:self];
        _rootVC.view.frame = self.view.bounds;
        _rootVC.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        _rootVC.view.layer.shadowOpacity =  0.8f;
        _rootVC.view.layer.shadowRadius = 10.0f;
        //        _rootVC.view.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds].CGPath;
    }
    
    [self resetRootViewNavBar];
    
    [self.view addSubview:self.rootVC.view];
    self.view.backgroundColor = [UIColor lightTextColor];
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    _tap.delegate = self;
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    _pan.delegate = self;
    [self.rootVC.view addGestureRecognizer:_tap];
    [self.rootVC.view addGestureRecognizer:_pan];
    
}
-(void)resetRootViewNavBar {
    if (!_rootVC)
        return;
    
    UIViewController *topVC;
    
    if ([_rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController*)_rootVC;
        if ([nav viewControllers].count > 0) {
            topVC = [[nav viewControllers] objectAtIndex:0];
        } else {
            return;
        }
    } else {
        topVC = _rootVC;
    }
    
    if (_leftVC) {
        UIBarButtonItem *lBtn = [[UIBarButtonItem alloc] initWithTitle:_navItemTitle style:UIBarButtonItemStyleDone target:self action:@selector(leftPressed:)];
        topVC.navigationItem.leftBarButtonItem = lBtn;
    }
    
    if (_rightVC) {
        UIBarButtonItem *lBtn = [[UIBarButtonItem alloc] initWithTitle:_navItemTitle style:UIBarButtonItemStyleDone target:self action:@selector(rigthPressed:)];
        topVC.navigationItem.rightBarButtonItem = lBtn;
    }
    
    
}
#pragma mark - GestureRecognizers
- (void)pan:(UIPanGestureRecognizer*)gesture {
    if (!_gestureEnable) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //获取rootview原点的x
        _panOriginX = _rootVC.view.frame.origin.x;
        //拖动的速率初始化
        _panVelocity = CGPointMake(0.0f, 0.0f);
        
        //判断是往左还是往右拖动
        if([gesture velocityInView:self.view].x > 0) {
            panDirection = SidePanDirectionRight;
        } else {
            panDirection = SidePanDirectionLeft;
        }
        
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        //获取拖动的速率；
        CGPoint velocity = [gesture velocityInView:self.view];
        //根据前一个和现在的速率判断是否要改变方向
        if((velocity.x*_panVelocity.x) < 0) {// + velocity.y*_panVelocity.y
            panDirection = (panDirection == SidePanDirectionRight) ? SidePanDirectionLeft : SidePanDirectionRight;
        }
        
        _panVelocity = velocity;
        //拖动的距离
        CGPoint translation = [gesture translationInView:self.view];
        /**
         下面是rootview拽动改变
         */
        CGRect frame = _rootVC.view.frame;
        frame.origin.x = _panOriginX + translation.x;
        if (c_flag == JXSplitNavigationControllerViewTypeRoot) {
            if (frame.origin.x > 0.0f) {
                if (_leftVC) {
                    c_flag = JXSplitNavigationControllerViewTypeLeft;
                    //[self showViewController:YES];
                } else {
                    frame.origin.x = 0;
                }
            } else {
                if (_rightVC) {
                    c_flag = JXSplitNavigationControllerViewTypeRight;
                    //[self showViewController:YES];
                } else {
                    frame.origin.x = 0.0f;
                    
                }
                
            }
        } else if (c_flag == JXSplitNavigationControllerViewTypeLeft) {
            if(frame.origin.x < 0)
                frame.origin.x = 0.0;
            
        } else if (c_flag == JXSplitNavigationControllerViewTypeRight){
            if (frame.origin.x > 0) {
                frame.origin.x  = 0;
            }
        }
        _rootVC.view.frame = frame;
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        [self.view setUserInteractionEnabled:NO];
        
        SidePanCompletion completion =SidePanCompletionRoot;
        if (panDirection == SidePanDirectionRight && _leftVC) {
            if(_rootVC.view.frame.origin.x > 0.0f )
                completion = SidePanCompletionLeft;
        } else if (panDirection == SidePanDirectionLeft && _rightVC) {
            if(_rootVC.view.frame.origin.x < 0.0f )
                completion = SidePanCompletionRight;
        }
        
        CGPoint velocity = [gesture velocityInView:self.view];
        if (velocity.x < 0.0f) {
            velocity.x *= -1.0f;
        }
        BOOL bounce = (velocity.x > 800);
        CGFloat originX = _rootVC.view.frame.origin.x;
        CGFloat width = _rootVC.view.frame.size.width;
        CGFloat span = (width - kMenuOverlayWidth(fabs(_offset)));
        CGFloat duration = kMenuSlideDuration; // default duration with 0 velocity
        
        
        if (bounce) {
            duration = (span / velocity.x); // bouncing we'll use the current velocity to determine duration
        } else {
            duration = ((span - originX) / span) * duration; // user just moved a little, use the defult duration, otherwise it would be too slow
        }
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (completion == SidePanCompletionLeft) {
                c_flag = JXSplitNavigationControllerViewTypeLeft;
            } else if (completion == SidePanCompletionRight) {
                c_flag = JXSplitNavigationControllerViewTypeRight;
            } else {
                c_flag = JXSplitNavigationControllerViewTypeRoot;
            }
            [self showViewController];
            
            [_rootVC.view.layer removeAllAnimations];
            [self.view setUserInteractionEnabled:YES];
        }];
        
        CGPoint pos = _rootVC.view.layer.position;
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        
        NSMutableArray *keyTimes = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounce ? 3 : 2];
        
        [values addObject:[NSValue valueWithCGPoint:pos]];
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [keyTimes addObject:[NSNumber numberWithFloat:0.0f]];
        if (bounce) {
            
            duration += kMenuBounceDuration;
            [keyTimes addObject:[NSNumber numberWithFloat:1.0f - ( kMenuBounceDuration / duration)]];
            if (completion == SidePanCompletionLeft) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(((width/2) + span) + kMenuBounceOffset, pos.y)]];
                
            } else if (completion == SidePanCompletionRight) {
                
                [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - (kMenuOverlayWidth(fabs(_offset))-kMenuBounceOffset)), pos.y)]];
                
            } else {
                
                // depending on which way we're panning add a bounce offset
                if (panDirection == SidePanDirectionLeft) {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) - kMenuBounceOffset, pos.y)]];
                } else {
                    [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + kMenuBounceOffset, pos.y)]];
                }
                
            }
            
            [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
            
        }
        if (completion == SidePanCompletionLeft) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake((width/2) + span, pos.y)]];
        } else if (completion == SidePanCompletionRight) {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(-((width/2) - kMenuOverlayWidth(_offset)), pos.y)]];
        } else {
            [values addObject:[NSValue valueWithCGPoint:CGPointMake(width/2, pos.y)]];
        }
        
        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [keyTimes addObject:[NSNumber numberWithFloat:1.0f]];
        
        animation.timingFunctions = timingFunctions;
        animation.keyTimes = keyTimes;
        //animation.calculationMode = @"cubic";
        animation.values = values;
        animation.duration = duration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [_rootVC.view.layer addAnimation:animation forKey:nil];
        [CATransaction commit];
        
    }
    
}
- (void)tap:(UITapGestureRecognizer*)gesture {
    
    //[gesture setEnabled:NO];
    [self showViewController];
    
}
#pragma mark - UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // Check for horizontal pan gesture
    if (gestureRecognizer == _pan) {
        UIPanGestureRecognizer *panGesture = (UIPanGestureRecognizer*)gestureRecognizer;
        CGPoint translation = [panGesture translationInView:self.view];
        if ([panGesture velocityInView:self.view].x < 600 && sqrt(translation.x * translation.x) / sqrt(translation.y * translation.y) > 1) {
            return YES;
        }
        return NO;
    }
    
    if (gestureRecognizer == _tap) {
        if (_rootVC && c_flag != JXSplitNavigationControllerViewTypeRoot) {
            BOOL f = CGRectContainsPoint(_rootVC.view.frame, [gestureRecognizer locationInView:self.view]);
            if (f) {
                c_flag = JXSplitNavigationControllerViewTypeRoot;
            }
            return f;
        }
        return NO;
        
    }
    return YES;
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == _tap) {
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded]&&[self.view window]) {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
