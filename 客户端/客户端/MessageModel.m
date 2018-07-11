//
//  MessageModel.m
//  客户端
//
//  Created by 陈小发 on 2018/6/26.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel
- (instancetype)initWithReciver:(NSString *)reciver Sender:(NSString *)sender Component:(NSString *)component {
    if (self=[super init]) {
        self.reciver=reciver;
        self.sender=sender;
        self.component=component;
    }
    return self;
}
@end
