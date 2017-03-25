//
//  MMMSendMessageView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMSendMessageView.h"

typedef void(^Block)();
typedef BOOL(^BeginTimerBlock)();

@interface MMMSendMessageView ()
@property (nonatomic, strong) UILabel *coverLabel;
@property (nonatomic, assign) int countDown;
@property (nonatomic, copy) BeginTimerBlock btnPressedBlock;
@property (nonatomic, strong) NSTimer *theTimer;
@end

@implementation MMMSendMessageView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
         self.backgroundColor = [UIColor clearColor];
        [self setTextField];
        [self setSendSMSBtn];
    }
    return self;
}

-(void)setTextField {
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, [UIScreen mainScreen].bounds.size.width/2-10, self.frame.size.height - 10)];
    _textField.backgroundColor = [UIColor clearColor];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.font = [UIFont systemFontOfSize:16];
//    _textField.placeholder = @"短信验证码";
    [self addSubview:_textField];
    
}

-(void)setSendSMSBtn {
    _sendMsgBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-[UIScreen mainScreen].bounds.size.width/3-20, (self.frame.size.height-35)/2, [UIScreen mainScreen].bounds.size.width/3, 35)];
//    [_sendMsgBtn setTitle:@"发送短信验证码" forState:UIControlStateNormal];
    [_sendMsgBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _sendMsgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _sendMsgBtn.layer.masksToBounds = YES;
    _sendMsgBtn.layer.cornerRadius = 5.0f;
    _sendMsgBtn.backgroundColor = [UIColor colorWithRed:120.0f/255.0f green:157.0f/255.0f blue:231.0f/255.0f alpha:1];
    _sendMsgBtn.center = CGPointMake(_sendMsgBtn.center.x, self.frame.size.height/2);
    [_sendMsgBtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendMsgBtn];
    
    
    _coverLabel = [[UILabel alloc]initWithFrame:_sendMsgBtn.frame];
    _coverLabel.font = [UIFont systemFontOfSize:16];
    _coverLabel.backgroundColor = [UIColor lightGrayColor];
    _coverLabel.layer.masksToBounds = YES;
    _coverLabel.layer.cornerRadius = 5.0f;
    _coverLabel.textColor = [UIColor blackColor];
    _coverLabel.textAlignment = NSTextAlignmentCenter;
    _coverLabel.hidden = YES;
    
    [self addSubview:_coverLabel];
}

-(void)sendMessage {
    
    
    BOOL BeginTimer;
    
    if (_btnPressedBlock) {
        BeginTimer = _btnPressedBlock();
    }
    
    if (BeginTimer) {
        _sendMsgBtn.enabled = NO;
        
        _theTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                             target:self
                                                           selector:@selector(timerFireMethod:)
                                                           userInfo:nil
                                                            repeats:YES];
        
        [[NSRunLoop currentRunLoop]addTimer:_theTimer forMode:NSRunLoopCommonModes];
        
        _coverLabel.hidden = NO;
        _coverLabel.text = @"60s后重新发送";
    }
    
}

-(void)sendMessageBtnPressed:(BOOL (^)())optionBlock {
    _btnPressedBlock = [optionBlock copy];
    
    
}

-(void)timerFireMethod:(NSTimer *)theTimer {
    
    Block smsMessageBlock = ^{
        int remainTime = 60 - ++_countDown;
        if (remainTime == 0) {
            _coverLabel.hidden = YES;
            _countDown = 0;
            _sendMsgBtn.enabled = YES;
            
            [_theTimer invalidate];
            _theTimer = nil;
        }else{
            _coverLabel.text = [NSString stringWithFormat:@"%is后重新发送",remainTime];
        }
    };
    
    
    smsMessageBlock();
    
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
