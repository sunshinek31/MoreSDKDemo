//
//  MMMCheckCodeView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMCheckCodeView.h"
#import "MMMConfigUtil.h"

@interface MMMCheckCodeView ()
@property(nonatomic, strong) UIImageView *checkImageView;
@end

@implementation MMMCheckCodeView
{
    BOOL _hasCheckCodeImage;
//    UIImageView *_checkImageView;
    UIControl *_control;

}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setTextField];
        [self setCheckCodeImageView];
        
        [self setCheckCodeBtn];
    }
    return self;
}

-(void)setTextField {
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width/2-10, self.frame.size.height - 10)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:16];
    _textField.placeholder = @"请输入图片验证码";
    [self addSubview:_textField];
    
}

-(void)setCheckCodeImageView {
    
    _checkImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width/3-20, (self.frame.size.height-35)/2, [UIScreen mainScreen].bounds.size.width/3, 35)];
    _checkImageView.backgroundColor = [UIColor lightGrayColor];
    _checkImageView.center = CGPointMake(_checkImageView.center.x, self.frame.size.height/2);
    
    
//    NSURL *url = [NSURL URLWithString:@"https://www.moneymoremore.com/merchant/checkCode.jsp"];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:imageData];
//    self.checkImageView.image = image;
    
    [MMMConfigUtil sharedConfigUtil].toCheckCode(@"",^(NSData *data, NSError *error){
        
        
        _control.enabled = YES;
        if (!error) {
            
            
            _checkImageView.image = [UIImage imageWithData:data];
            //            [self.checkCodeBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }
    });
    [self addSubview:_checkImageView];
}

-(void)setCheckCodeBtn {
    _checkCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width/3-20, (self.frame.size.height-35)/2, [UIScreen mainScreen].bounds.size.width/3, 35)];
    _checkCodeBtn.backgroundColor = [UIColor clearColor];
    
//    self.checkCodeBtn.enabled = NO;
//    [MMMConfigUtil sharedConfigUtil].toCheckCode(@"",^(NSData *data, NSError *error){
//        self.checkCodeBtn.enabled = YES;
//        _control.enabled = YES;
//        if (!error) {
//            _checkImageView.image = [UIImage imageWithData:data];
//        }
//    });
    _checkCodeBtn.center = CGPointMake(_checkCodeBtn.center.x, self.frame.size.height/2);
    [_checkCodeBtn addTarget:self action:@selector(changeCheckCode) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_checkCodeBtn];
}

-(void)changeCheckCode {
    
//    NSURL *url = [NSURL URLWithString:@"https://www.moneymoremore.com/merchant/checkCode.jsp"];
//    NSData *imageData = [NSData dataWithContentsOfURL:url];
//    UIImage *image = [UIImage imageWithData:imageData];
//    self.checkImageView.image = image;
    
    self.checkCodeBtn.enabled = NO;
    [MMMConfigUtil sharedConfigUtil].toCheckCode(@"",^(NSData *data, NSError *error){
        self.checkCodeBtn.enabled = YES;
        _control.enabled = YES;
        if (!error) {
            _checkImageView.image = [UIImage imageWithData:data];
//            [self.checkCodeBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }
    });
}

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect textFieldRect = CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width-20, self.frame.size.height - 10);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, textFieldRect);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, textFieldRect);
    CGContextStrokePath(context);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
