//
//  LogInViewController.m
//  客户端
//
//  Created by 陈小发 on 2018/6/5.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import "LogInViewController.h"
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import "GCDAsyncSocket.h"
#import "UserInfo.h"
#import "ContactModel.h"
//#define IPAddress @"192.168.0.101"//手机的局域网IP
//#define IPAddress @"192.168.0.104"// 这是我电脑的局域网IP
#define IPAddress @"127.0.0.1"//本机
#define BaseHeartStr @"HeartPackage" //心跳包

@interface LogInViewController ()<GCDAsyncSocketDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (assign, nonatomic) int server_socket;// 服务器的socket
@property (strong, nonatomic) NSTimer *myTimer;//定时发送心跳包
@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) MainViewController *mvc;
@end

@implementation LogInViewController

// TODO:点击登录就开始发送登录请求
- (IBAction)loginAction:(id)sender {
    if(![self.socket isConnected]) {
        NSError *err=nil;
        int t = [self.socket connectToHost:IPAddress onPort:38383 error:&err];
        if (t==0)
        {
            NSLog(@"链接失败");
        }else {
            NSLog(@"连接成功");
        }
    }else {
        [self loginActionWithUsername:self.userNameField.text];
    }
}
// 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    BOOL state = [self.socket isConnected];  // 判断是否连接成功
    if (state) {
        NSLog(@"有连接");
        
    }else{
        NSLog(@"socket 没有连接");
    }
}

//发送登录请求
- (void)loginActionWithUsername:(NSString *)name {
    //此处我用一个字典来装这些
    NSDictionary *dic=@{@"name":name,@"action":@"LogIn"};
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    //我规定了0 就是登录请求
    [self.socket writeData:data withTimeout:-1 tag:0];
    [self.socket readDataWithTimeout:-1 tag:0];
}


// 读取服务器返回回来的数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dict);
    printf("tag==%ld",tag);
    NSNumber *flag=dict[@"tag"];
    if ([flag isEqualToNumber:@0]) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        self.mvc=[MainViewController new];
        self.mvc.socket=sock;
        UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:self.mvc];
        if ([[dict objectForKey:@"success"] isEqual:@1]) {
            NSArray *array=[dict objectForKey:@"users"];
            if (self.mvc.contactArray.count==0) {
                for (NSInteger i=0; i<array.count; i++) {
                    ContactModel *model=[[ContactModel alloc]initWithName:array[i]];
                    [self.mvc.contactArray addObject:model];
                }
            }
            
            [self presentViewController:nav animated:YES completion:nil];
            UserInfo *user=[UserInfo shareInstance];
            user.name=_userNameField.text;
        }
    }
    // TODO: 发送信息
    if ([flag isEqualToNumber:@1]) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([[dict objectForKey:@"success"] isEqual:@1]) {
            NSLog(@"发送信息成功");
        }else {
            NSLog(@"发送信息失败");
        }
    }
    
    // TODO: 接收信息
    if ([flag isEqualToNumber:@2]) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        MessageModel *model=[[MessageModel alloc]initWithReciver:dict[@"reciver"] Sender:dict[@"sender"] Component:dict[@"text"]];
        [self.mvc reciveMessage:model];
        NSLog(@"接收信息");
    }
    
    // TODO: 接收通讯录列表更新信息
    if ([flag isEqualToNumber:@3]) {
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *array=[dict objectForKey:@"users"];
        NSMutableArray *marray=[NSMutableArray array];
        for (NSInteger i=0; i<array.count; i++) {
            ContactModel *model=[[ContactModel alloc]initWithName:array[i]];
            [marray addObject:model];
        }
        self.mvc.contactArray=marray;
        [self.mvc.tableView reloadData];
    }
    [self.socket readDataWithTimeout:-1 tag:0];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.socket = [[GCDAsyncSocket alloc]init];
    self.socket.delegate=self;
    self.socket.delegateQueue=dispatch_get_main_queue();
    
    NSError *err=nil;
    int t = [self.socket connectToHost:IPAddress onPort:38383 error:&err];
    
    if (t==0)
    {
        NSLog(@"链接失败");
    }else {
        NSLog(@"连接成功");
    }
}

@end
