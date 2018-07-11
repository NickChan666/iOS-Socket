//
//  MessageCell.m
//  客户端
//
//  Created by 陈小发 on 2018/6/9.
//  Copyright © 2018年 陈小发. All rights reserved.
//

#import "MessageCell.h"
@interface MessageCell ()
@end
@implementation MessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layer.borderColor=[UIColor lightGrayColor].CGColor;
//    self.layer.borderWidth=2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (MessageModel *)model {
    self.name.text=_model.sender;
    self.text.text=_model.component;
    return _model;
}

@end
