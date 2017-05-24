//
//  JXHttpClientDemo.m
//  Framework
//
//  Created by wangjunxin on 15-12-11.
//  Copyright (c) 2015年 HuaTeng. All rights reserved.
//

#import "JXHttpClientDemo.h"

@interface JXHttpClientDemo ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *getTV;

@property (weak, nonatomic) IBOutlet UITextField *postTV;
@property (weak, nonatomic) IBOutlet UIScrollView *parmSV;
@end

@implementation JXHttpClientDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)addPramAction:(UIStepper*)sender {
 
    
    
}
- (IBAction)getRequest:(id)sender {
    
    
    
    
}
- (IBAction)postRequest:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:NO];
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
