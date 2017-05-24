//
//  JXTableViewController.m
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "JXTableViewController.h"
#import "JXUITableViewCell.h"
@interface JXTableViewController ()
@property (nonatomic) NSMutableArray *filterdata;
@property (nonatomic) UITableViewStyle style;
@property (nonatomic) NSString *headerNibName;
@property (nonatomic) NSString *cellNibName;
@property (nonatomic) Class cellClass;
@property (nonatomic) NSString *footerNibName;
@property (nonatomic) UIView *disableViewOverlay;
@end
static NSString * const cellIdentifier = @"cell";
@implementation JXTableViewController

//重写
+ (instancetype)viewControllerWithCellNib:(NSString *)cellNibName style:(UITableViewStyle)style {
    JXTableViewController *ctrl = [[JXTableViewController alloc] init];
    ctrl.cellNibName = cellNibName;
    ctrl.style = style;
    return ctrl;
}

+ (instancetype)viewControllerWithCellClass:(Class)cellClass style:(UITableViewStyle)style {
    JXTableViewController *ctrl = [[JXTableViewController alloc] init];
    ctrl.cellClass = cellClass;
    ctrl.style = style;
    return ctrl;
}
- (void)setData:(NSArray *)data {
    _data = data;
    _filterdata = [NSMutableArray arrayWithArray:data];
    
}

- (void)appendData:(NSArray *)data {
    _data = [_data arrayByAddingObjectsFromArray:data];
    _filterdata = [NSMutableArray arrayWithArray:_data];
}

- (void)refresh {
    [self.tableView reloadData];
    if (self.refreshControl.refreshing) {
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"上次刷新: %@",@"XXX"]];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if ([_cellNibName length]>0) {
        [self.tableView registerNib:[UINib nibWithNibName:_cellNibName bundle:nil] forCellReuseIdentifier:cellIdentifier];
        
    }else if (_cellClass){
        [self.tableView registerClass:_cellClass forCellReuseIdentifier:cellIdentifier];
    }else{
        [self.tableView registerClass:[JXUITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    }
    if (_supportPullToRefresh) {
        [self installRefreshControl];
        
    }
    if (_supportSearchBar) {
        [self installSearchBar];
    }
    [self refresh];
}
- (void)installRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor blueColor];
    [self.refreshControl addTarget:self action:@selector(controlEventValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
}
- (void)installSearchBar {
    UISearchBar *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchbar.placeholder = @"please enter keyword";
    searchbar.autocorrectionType = UITextAutocapitalizationTypeNone;
    searchbar.showsCancelButton = YES;
    searchbar.delegate = self;//设置代理
    [searchbar sizeToFit];
    self.tableView.tableHeaderView = searchbar;
    
}

- (void)controlEventValueChanged:(id)sender {
    if(self.refreshControl.refreshing){
        if ([self.delegate respondsToSelector:@selector(tableView:willRefreshData:)]) {
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
            [self.delegate tableView:self willRefreshData:YES];
        }else{
            [self.refreshControl endRefreshing];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return [_filterdata count]+ (_total > _filterdata.count ? 1: 0);
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == _filterdata.count) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"点击加载更多数据";
        
    }
    UITableViewCell<JXUITableViewDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (cell) {
        [cell render:[self.filterdata objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _filterdata.count) {
        if ([self.delegate respondsToSelector:@selector(tableView:willLoadMoreData:)]) {
            [self.delegate tableView:self willLoadMoreData:YES];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:data:)]) {
            NSDictionary *data = [self.data objectAtIndex:indexPath.row];
            [self.delegate tableView:self didSelectRowAtIndexPath:indexPath.row data:data];
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
