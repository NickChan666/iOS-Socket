//
//  ChatVC.h
//  客户端
//
//  Created by 陈小发 on 2018/6/27.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
#import "MessageCell.h"

@protocol SendDelegate
- (void)sendDelegate:(MessageModel *)model;

@end


@interface ChatVC : UIViewController

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ContactModel *contactModel;
@property (nonatomic, weak)   id<SendDelegate>delegate;
@end
