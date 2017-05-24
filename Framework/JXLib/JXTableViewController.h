//
//  JXTableViewController.h
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXTableViewController;
@protocol JXTableViewDelegate <NSObject>

@optional
- (void)tableView:(JXTableViewController *)tableView didSelectRowAtIndexPath:(NSInteger)index data:(id)data;
- (void)tableView:(JXTableViewController *)tableView willRefreshData:(BOOL)willRefreshData;
- (void)tableView:(JXTableViewController *)tableView willLoadMoreData:(BOOL)willRefreshData;
- (NSArray *)tableView:(JXTableViewController *)tableView filterText:(NSString *)filterText;
- (void)tableView:(JXTableViewController *)tableView searchText:(NSString *)searchText;

@end


@interface JXTableViewController : UITableViewController<UISearchBarDelegate>
@property (nonatomic) NSInteger total;
@property (nonatomic) NSArray *data;
@property (nonatomic) BOOL supportPullToRefresh;
@property (nonatomic) BOOL supportSearchBar;
@property  id<JXTableViewDelegate> delegate;

+ (instancetype)viewControllerWithCellNib:(NSString *)cellNibName style:(UITableViewStyle)style;

+ (instancetype)viewControllerWithCellClass:(Class)cellClass style:(UITableViewStyle)style;
- (void)appendData:(NSArray *)data;

- (void)refresh;

@end
