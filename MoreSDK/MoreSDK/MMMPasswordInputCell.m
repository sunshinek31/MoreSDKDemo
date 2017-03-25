//
//  MMMPasswordInputCell.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMPasswordInputCell.h"

@implementation MMMPasswordInputCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self setPasswordTextField];
        
        _helpBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width-20-10, 30)];
        _helpBtn.backgroundColor = [UIColor clearColor];
        [_helpBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_helpBtn setTitle:@"(非支付密码 忘记密码?)" forState:UIControlStateNormal];
        [_helpBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        _helpBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_helpBtn];
    }
    return self;
}
-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect contextRect = CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width-20, 70);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, contextRect);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, contextRect);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 100.0f/255.0f, 149.0f/255.0f, 237.0f/255.0f, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 10, 40);
    CGContextAddLineToPoint(context, self.frame.size.width-10, 40);
    
    CGContextStrokePath(context);
}

-(void)setPasswordTextField {
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _titleLabel.text = @"登陆密码: ";
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(20, 10, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    [self addSubview:_titleLabel];
    
    _passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(20+_titleLabel.frame.size.width, 10, [UIScreen mainScreen].bounds.size.width-10-20-_titleLabel.frame.size.width, _titleLabel.frame.size.height)];
    _passwordTextField.placeholder = @"请输入";
    _passwordTextField.font = [UIFont systemFontOfSize:16];
    _passwordTextField.delegate = (id)self;
    _passwordTextField.secureTextEntry = YES;
    [self addSubview:_passwordTextField];
}
@end
