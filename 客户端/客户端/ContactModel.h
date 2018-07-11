//
//  ContactModel.h
//  客户端
//
//  Created by 陈小发 on 2018/6/26.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
@interface ContactModel : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray <MessageModel *>*array;

-(instancetype)initWithName:(NSString *)name;
@end
