//
//  MainViewController.h
//  客户端
//
//  Created by 陈小发 on 2018/6/4.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCDAsyncSocket.h"
#import "MessageModel.h"
#import "MessageCell.h"
#import "ContactModel.h"
@interface MainViewController : UIViewController

@property (strong, nonatomic) GCDAsyncSocket *socket;
@property (strong, nonatomic) NSMutableArray <ContactModel *>*contactArray;
@property (strong, nonatomic) UITableView *tableView;
// TODO: 接收信息的方法
- (void)reciveMessage:(MessageModel *)model;
@end
