//
//  JXUIButton.h
//  Framework
//
//  Created by junxinWang on 15-7-24.
//  Copyright (c) 2015年 HuaTeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum jxuibuttontype {
    JXButtonBordyIsFong = 0,
    JXButtonBordyIsRound,
    JXButtonBordyIsProtruding,
    
}JXUIButtonType;

@protocol JXUIButton <NSObject>

- (void)addseletBtu:(id)select :(UIColor *)color;

@end


@interface JXUIButton : UIView




@end
