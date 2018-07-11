//
//  ContactModel.m
//  客户端
//
//  Created by 陈小发 on 2018/6/26.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import "ContactModel.h"

@implementation ContactModel
- (instancetype)initWithName:(NSString *)name {
    if (self=[super init]) {
        self.name=name;
        self.array=[NSMutableArray array];
    }
    return self;
}
@end
