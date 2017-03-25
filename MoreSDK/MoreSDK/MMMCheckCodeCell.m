//
//  MMMCheckCodeCell.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMCheckCodeCell.h"

@implementation MMMCheckCodeCell
{
    BOOL _hasCheckCodeImage;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self setTextField];
        [self setCheckCodeBtn];
    }
    return self;
}

-(void)setTextField {
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width/2-10, 50)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.placeholder = @"请输入图片验证码";
    [self addSubview:_textField];
    
}

-(void)setCheckCodeBtn {
    _checkCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width/3-20, 5, [UIScreen mainScreen].bounds.size.width/3, 35)];
    _checkCodeBtn.backgroundColor = [UIColor whiteColor];
    _checkCodeBtn.center = CGPointMake(_checkCodeBtn.center.x, self.frame.size.height/2);
    [self addSubview:_checkCodeBtn];
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect textFieldRect = CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, 50);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, textFieldRect);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, textFieldRect);
    CGContextStrokePath(context);
}

-(void)dealloc {
    
}
@end
