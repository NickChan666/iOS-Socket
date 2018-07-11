//
//  UserInfo.h
//  客户端
//
//  Created by 陈小发 on 2018/6/5.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
@interface UserInfo : NSObject

@property (nonatomic, strong) NSString *name;
+ (UserInfo *)shareInstance;
//+ (GCDAsyncSocket *)shareSocket;

@end
