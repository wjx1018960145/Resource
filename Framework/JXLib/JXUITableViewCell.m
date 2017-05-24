//
//  JXUITableViewCell.m
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "JXUITableViewCell.h"

@implementation JXUITableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)render:(id)data {
    self.textLabel.text = data[@"name"];
}
@end
