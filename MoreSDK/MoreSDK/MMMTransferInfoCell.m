//
//  MMMTransferInfoCell.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/26.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMTransferInfoCell.h"

@implementation MMMTransferInfoCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, [UIScreen mainScreen].bounds.size.width-40, 30)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
    
        _contentLabel_1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, [UIScreen mainScreen].bounds.size.width-40, 30)];
        _contentLabel_1.backgroundColor = [UIColor clearColor];
        _contentLabel_1.font = [UIFont systemFontOfSize:14];
        _contentLabel_1.textColor = [UIColor blackColor];
        
        _contentLabel_2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, [UIScreen mainScreen].bounds.size.width-40, 30)];
        _contentLabel_2.backgroundColor = [UIColor clearColor];
        _contentLabel_2.font = [UIFont systemFontOfSize:14];
        _contentLabel_2.textColor = [UIColor blackColor];
        
        [self addSubview:_titleLabel];
        [self addSubview:_contentLabel_1];
        [self addSubview:_contentLabel_2];
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect contextRect_1 = CGRectMake(10, 35, [UIScreen mainScreen].bounds.size.width-20, 60);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, contextRect_1);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, contextRect_1);
    CGContextStrokePath(context);
    
    CGRect contextRect_2 = CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, 30);
    CGContextSetRGBFillColor(context, 220.0f/255.0f, 226.0f/255.0f, 236.0f/255.0f, 1.0);
    CGContextFillRect(context, contextRect_2);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, contextRect_2);
    CGContextStrokePath(context);
}
@end
