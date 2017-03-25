//
//  MMMBindListCell.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/28.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBindListCell.h"

@implementation MMMBindListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setTitle:(NSString *)account1
       account2:(NSString *)account2
       realName:(NSString *)name
   identifierId:(NSString *)identifierId
{
    if (!_label_1) {
        _label_1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.frame.size.width-40, 25)];
        _label_1.font = [UIFont systemFontOfSize:12];
        _label_1.text = [NSString stringWithFormat:@"账户 : %@ | %@",account1,account2];
        [_label_1 sizeToFit];
        _label_1.frame = CGRectMake(20, self.frame.size.height/2-_label_1.frame.size.height, self.frame.size.width-40, _label_1.frame.size.height);
        [self addSubview:_label_1];
    }
    _label_1.text = [NSString stringWithFormat:@"账户 : %@ | %@",account1,account2];
    
    if (!_label_2) {
        _label_2 = [[UILabel alloc]initWithFrame:CGRectMake(20, self.frame.size.height/2, self.frame.size.width-40, 25)];
        _label_2.font = [UIFont systemFontOfSize:12];
        _label_2.text = [NSString stringWithFormat:@"姓名 : %@ 身份证 : %@",name,identifierId];
        [_label_2 sizeToFit];
        _label_2.frame = CGRectMake(20, self.frame.size.height/2, self.frame.size.width-40, _label_2.frame.size.height);
        [self addSubview:_label_2];
    }
    _label_2.text = [NSString stringWithFormat:@"姓名 : %@ 身份证 : %@",name,identifierId];
    
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect contextRect = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 50);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, contextRect);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, contextRect);
    CGContextStrokePath(context);
}

@end
