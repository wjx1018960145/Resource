//
//  JXCustomHigherUI.m
//  Framework
//
//  Created by junxinWang on 15-7-24.
//  Copyright (c) 2015年 HuaTeng. All rights reserved.
//

#import "JXCustomHigherUI.h"
#import "GestureView.h"
#define kMargin_Left_SC     10
#define kMargin_Top_SC      30
#define kWidth_SC           300
#define kHeight_SC          30

#define kMargin_Left_IM        70
#define kMargin_Between_SI     40    //segmentedControl与imageView的间距
#define kWidth_IM              180
#define kHeight_IM             300
#define kMargin_Top_IM       (kHeight_SC+kMargin_Top_SC+kMargin_Between_SI)

@interface JXCustomHigherUI ()<GestureViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    UIButton *btu;
    UILabel *label;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JXCustomHigherUI

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSeagment];
    UICollectionViewFlowLayout *collectionFlowlayout = [[UICollectionViewFlowLayout alloc] init];
    //设置item大小
    collectionFlowlayout.itemSize = CGSizeMake(self.view.frame.size.width/2.13, self.view.frame.size.height/5.68);
    //设置边界锁紧
    collectionFlowlayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    //设置行与行之间的间隔
    collectionFlowlayout.minimumInteritemSpacing = 5;
    //设置列与列之间的间隔
    collectionFlowlayout.minimumLineSpacing = 5;
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-1*(label.frame.origin.y+label.frame.size.height)) collectionViewLayout:collectionFlowlayout];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-1*(label.frame.origin.y+label.frame.size.height)) style:UITableViewStylePlain];
    
    
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tableView];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectioncell"];
    
    
}

- (void)setUpSeagment {
    //初始化分段控制器
    //布局segmentedControl
    NSArray *items = @[@"社区", @"分类"];
    
    for (int i = 0; i < 2; i++) {
        btu = [UIButton buttonWithType:UIButtonTypeSystem];
        btu.frame = CGRectMake(53*i+106, 66, 53, 30);
        [btu setTitle:items[i] forState:UIControlStateNormal];
        btu.tag = 100+i;
        [btu addTarget:self action:@selector(selectBtu:) forControlEvents:UIControlEventTouchUpInside];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, btu.frame.size.height+btu.frame.origin.y, self.view.frame.size.width, 1)];
        
        label.backgroundColor = [UIColor grayColor];
        [self.view addSubview:label];
        [self.view addSubview:btu];
    }
    
    
    GestureView *gestureView = [[GestureView alloc] initWithFrame:[[UIScreen mainScreen] bounds] items:items];
    //初始化时,imageView上显示美女图片
   // gestureView.imageView.image = _girlsArr[0];
    gestureView.delegate = self;
    //self.view = gestureView;
  
    
}


- (void)selectBtu:(UIButton*)sender  {
    NSLog(@"%@",self.view.subviews);
    switch (sender.tag) {
        case 100:
        {
         [UIView animateWithDuration:2 delay:2 options:nil animations:^{
         [self.view  exchangeSubviewAtIndex:4 withSubviewAtIndex:5];
             
         } completion:^(BOOL finished) {
             
         }];
           
            
        }
            break;
        case 101:
        {
        [self.view  exchangeSubviewAtIndex:5 withSubviewAtIndex:4];
            
        }
            break;
        default:
            break;
    }
    
    
}//处理segmentControl切换事件
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    return cell;
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded]&&[self.view window]) {
        self.view = nil;
    }
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
