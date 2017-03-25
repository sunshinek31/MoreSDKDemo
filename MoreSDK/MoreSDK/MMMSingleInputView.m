//
//  MMMSingleInputView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMSingleInputView.h"

@implementation MMMSingleInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(_titleLabel.frame.size.width+5+12, 0, self.frame.size.width-_titleLabel.frame.size.width-10-10-5, self.frame.size.height)];
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
    CGContextFillRect(context, CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, self.frame.size.height-10));
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, self.frame.size.height-10));
    CGContextStrokePath(context);
}

- (void)setArrow {
    
    UIImage *image = [UIImage imageNamed:@"MMMBankSDK.bundle/arrow"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    imageView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 10 - 11, 22, 10, 15);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageView];
}

@end
