//
//  MMMAuthorizeInfoCell.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMAuthorizeInfoCell.h"

@implementation MMMAuthorizeInfoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 120+10+10);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self setAllLabel];
    }
    return self;
}

-(void)setAllLabel {
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectZero];
    title.text = @"当前状态: ";
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentRight;
    [title sizeToFit];
    title.frame = CGRectMake(10, 10, 100, 40);
    [self addSubview:title];
    
    _authorizeOpenedLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 10, [UIScreen mainScreen].bounds.size.width-10-120, 80)];
    _authorizeOpenedLabel.numberOfLines = 3;
    _authorizeOpenedLabel.textAlignment = NSTextAlignmentLeft;
    _authorizeOpenedLabel.font = [UIFont systemFontOfSize:16];
    _authorizeOpenedLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_authorizeOpenedLabel];
    
    _authorizeTitleLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, 100, 50)];
    _authorizeTitleLable.text = @"本次开启: ";
    _authorizeTitleLable.font = [UIFont systemFontOfSize:16];
    _authorizeTitleLable.textAlignment = NSTextAlignmentRight;
    _authorizeTitleLable.numberOfLines = 2;
    [self addSubview:_authorizeTitleLable];
    
    _authorizeContent = [[UILabel alloc]initWithFrame:CGRectMake(120, 90, [UIScreen mainScreen].bounds.size.width-10-120, 50)];
    _authorizeContent.font = [UIFont systemFontOfSize:16];
    _authorizeContent.textAlignment = NSTextAlignmentLeft;
    _authorizeContent.numberOfLines = 2;
    [self addSubview:_authorizeContent];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect contextRect = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 130+10);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, contextRect);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, contextRect);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 100.0f/255.0f, 149.0f/255.0f, 237.0f/255.0f, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10, 90);
    CGContextAddLineToPoint(context, self.frame.size.width-10, 90);
    
    CGContextStrokePath(context);
}
@end
