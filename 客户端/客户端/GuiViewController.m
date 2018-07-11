//
//  GuiViewController.m
//  客户端
//
//  Created by 陈小发 on 2018/6/4.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import "GuiViewController.h"

@interface GuiViewController ()

@end

@implementation GuiViewController
- (IBAction)logOut:(id)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)presentMainVC:(id)sender {
    
    LogInViewController *loginVC=[[LogInViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
