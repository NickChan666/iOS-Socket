//
//  UserInfo.m
//  客户端
//
//  Created by 陈小发 on 2018/6/5.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(UserInfo *) shareInstance{
    static UserInfo * user = nil;
    static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
        user = [[super alloc]init];
    });
    return user;
}

@end
