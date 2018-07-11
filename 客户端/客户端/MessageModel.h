//
//  MessageModel.h
//  客户端
//
//  Created by 陈小发 on 2018/6/26.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (strong, nonatomic) NSString *reciver;
@property (strong, nonatomic) NSString *sender;
@property (strong, nonatomic) NSString *component;

- (instancetype)initWithReciver:(NSString *)reciver Sender:(NSString *)sender Component:(NSString *)component;

@end
