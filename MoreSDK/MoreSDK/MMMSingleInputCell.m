//
//  MMMSingleInputCell.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMSingleInputCell.h"

@implementation MMMSingleInputCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setTitleContent:(NSString *)titleContent {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, self.frame.size.width-20, self.frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
//        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _textField.text = titleContent;
        [self addSubview:_titleLabel];
    }
}

-(void)setTitleContent:(NSString *)titleContent andDetailContent:(NSString *)detailContent {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, 80, self.frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentRight;
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLabel];
    }
    
    if (!_textField) {
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(_titleLabel.frame.size.width+5+12, 0, self.contentView.frame.size.width-_titleLabel.frame.size.width-10-10-5, self.frame.size.height)];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.placeholder = @"请输入";
        [self addSubview:_textField];
    }
    
    if (titleContent) {
        _titleLabel.text = titleContent;
    }
    
    if (detailContent && ![[detailContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]) {
        _textField.text = detailContent;
    }
}


-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, 50));
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, 50));
    CGContextStrokePath(context);
}

@end
