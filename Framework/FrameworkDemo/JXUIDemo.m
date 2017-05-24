//
//  JXUIDemo.m
//  Framework
//
//  Created by junxinWang on 15-7-22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "JXUIDemo.h"
#import "JXUtil.h"
@interface JXUIDemo ()
@property (nonatomic) NSArray *data;
@end

@implementation JXUIDemo

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
     NSString *path = [JXUtil pathOfResource:@"uicatagory.geojson"];
    self.data = [JXUtil string2json:[[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]] ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded]&&[self.view window]) {
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return self.data.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _data[section][@"name"];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return[_data[section][@"children"] count];;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *data = _data[indexPath.section][@"children"][indexPath.row];
    UIViewController *detailViewController;
    
    if ([data[@"controllerClass"] length] > 0) {
        Class c = NSClassFromString(data[@"controllerClass"]);
        if (c) {
            detailViewController = [[c alloc] init];
        }
    }
    if ([data[@"controllerNib"] length] > 0) {
        Class c = NSClassFromString(data[@"controllerNib"]);
        if (c) {
            detailViewController = [[c alloc] initWithNibName:data[@"controllerNib"] bundle:nil];
        }
    }
    detailViewController.title = data[@"name"];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = _data[indexPath.section][@"children"][indexPath.row][@"name"];
    return cell;
}


@end
