//
//  MessageCell.h
//  客户端
//
//  Created by 陈小发 on 2018/6/9.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
@interface MessageCell : UITableViewCell
@property (strong, nonatomic) MessageModel *model;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *text;
@end
