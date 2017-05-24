//
//  JXUITableViewCell.h
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXUITableViewDelegate <NSObject>
@required
- (void)render:(id)data;

@end


@interface JXUITableViewCell : UITableViewCell<JXUITableViewDelegate>

@end
