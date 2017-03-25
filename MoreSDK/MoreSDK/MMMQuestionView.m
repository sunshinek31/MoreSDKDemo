//
//  MMMQuestionView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMQuestionView.h"

@implementation MMMQuestionView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _questionTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _answerTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        
        _questionTitleLabel.textAlignment = _answerTitleLabel.textAlignment = NSTextAlignmentRight;
        _questionTitleLabel.font = _answerTitleLabel.font = [UIFont systemFontOfSize:16];
        
        _questionTitleLabel.frame = CGRectMake(10, 10, 50, (frame.size.height-10)/2);
        _answerTitleLabel.frame = CGRectMake(10, (frame.size.height+10)/2, 50, (frame.size.height-10)/2);
        
        _questionTitleLabel.text = @"问题1: ";
        _answerTitleLabel.text = @"答案1: ";
        
        _questionCustomBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_questionCustomBtn setTitle:@"自定义" forState:UIControlStateNormal];
        _questionCustomBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_questionCustomBtn sizeToFit];
        [_questionCustomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _questionCustomBtn.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1];
        _questionCustomBtn.layer.masksToBounds = YES;
        _questionCustomBtn.layer.cornerRadius = 5.0f;
        _questionCustomBtn.frame = CGRectMake(0, 0, _questionCustomBtn.frame.size.width, _questionCustomBtn.frame.size.height-10);
        _questionCustomBtn.center = CGPointMake(frame.size.width-15-_questionCustomBtn.frame.size.width/2, (frame.size.height-10)/4+10);
        
        
        _questionSwitchBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_questionSwitchBtn setTitle:@"--请选择安保问题--" forState:UIControlStateNormal];
        _questionSwitchBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_questionSwitchBtn sizeToFit];
        [_questionSwitchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _questionSwitchBtn.backgroundColor = [UIColor colorWithRed:228.0f/255.0f green:228.0f/255.0f blue:228.0f/255.0f alpha:1];
        _questionSwitchBtn.layer.masksToBounds = YES;
        _questionSwitchBtn.layer.cornerRadius = 5.0f;
        
        float origin_x = _questionTitleLabel.frame.origin.x+_questionTitleLabel.frame.size.width+10;
        _questionSwitchBtn.frame = CGRectMake(origin_x,
                                              _questionCustomBtn.frame.origin.y,
                                              _questionCustomBtn.frame.origin.x-origin_x-10,
                                              _questionCustomBtn.frame.size.height);
        
        
        _answerTextField = [[UITextField alloc]initWithFrame:CGRectMake(origin_x,
                                                                        _questionCustomBtn.frame.origin.y+((frame.size.height-10)/2),
                                                                        _questionCustomBtn.frame.origin.x-origin_x-10,
                                                                        _questionCustomBtn.frame.size.height)];
        _answerTextField.backgroundColor = [UIColor clearColor];
        _answerTextField.textAlignment = NSTextAlignmentLeft;
        _answerTextField.placeholder = @"请输入安保问题答案";
        _answerTextField.font = [UIFont systemFontOfSize:16];
        
        _questionTitleTextField = [[UITextField alloc]initWithFrame:_questionSwitchBtn.frame];
        _questionTitleTextField.backgroundColor = [UIColor whiteColor];
        _questionTitleTextField.placeholder = @"请设置安保问题";
        _questionTitleTextField.font = [UIFont systemFontOfSize:16];
        _questionTitleTextField.textAlignment = NSTextAlignmentLeft;
        _questionTitleTextField.hidden = YES;
        
        
        [self addSubview:_answerTextField];
        [self addSubview:_questionSwitchBtn];
        [self addSubview:_questionCustomBtn];
        [self addSubview:_questionTitleLabel];
        [self addSubview:_answerTitleLabel];
        [self addSubview:_questionTitleTextField];
    }
    return self;
}

-(void)setquestionTitle:(NSString *)title {
    if (title== nil || [title isEqualToString:@""]) {
        [_questionSwitchBtn setTitle:@"--请选择安保问题--" forState:UIControlStateNormal];
    }else{
        [_questionSwitchBtn setTitle:title forState:UIControlStateNormal];
    }
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect contextRect = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height-10);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1.0);
    CGContextFillRect(context, contextRect);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextSetLineWidth(context, 0.3);
    CGContextAddRect(context, contextRect);
    CGContextStrokePath(context);
    
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,10, (self.frame.size.height+10)/2);
    CGContextAddLineToPoint(context, self.frame.size.width-10, (self.frame.size.height+10)/2);
    
    CGContextStrokePath(context);
}
@end
