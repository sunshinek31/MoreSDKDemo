//
//  MMMRegisterBindInfoCell.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMRegisterBindInfoCell.h"

@implementation MMMRegisterBindInfoCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50);
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
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

-(void)setRegisterInfo:(NSString *)title
          registerName:(NSString *)registerName
         certificateID:(NSString *)certificateID
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(0, self.center.y);
    _titleLabel.frame = CGRectMake(20, _titleLabel.frame.origin.y, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    [self addSubview:_titleLabel];
    
    CGRect titleFrame = _titleLabel.frame;
    if (!_registerNameTextField) {
        _registerNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleFrame.size.width+20, 0, 200, 25)];
    }
    _registerNameTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleFrame.size.width+20, 0, 200, 25)];
    _registerNameTextField.text = registerName;
    _registerNameTextField.font = [UIFont systemFontOfSize:12];
    [_registerNameTextField sizeToFit];
    _registerNameTextField.frame = CGRectMake(titleFrame.size.width+20, self.frame.size.height/2-_registerNameTextField.frame.size.height, 200, _registerNameTextField.frame.size.height);
    [self addSubview:_registerNameTextField];
    
    
    if (!_certificateIDTextField) {
        _certificateIDTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleFrame.size.width+20, 0, 200, 25)];
    }
    _certificateIDTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleFrame.size.width+20, 0, 200, 25)];
    _certificateIDTextField.text = certificateID;
    _certificateIDTextField.font = [UIFont systemFontOfSize:12];
    [_certificateIDTextField sizeToFit];
    _certificateIDTextField.frame = CGRectMake(titleFrame.size.width+20, self.frame.size.height/2, 200, _certificateIDTextField.frame.size.height);
    [self addSubview:_certificateIDTextField];
}

-(void)setContentText:(NSString *)content{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    
    _titleLabel.text = content;
    _titleLabel.font = [UIFont systemFontOfSize:12];
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(0, self.center.y);
    _titleLabel.frame = CGRectMake(20, _titleLabel.frame.origin.y, _titleLabel.frame.size.width, _titleLabel.frame.size.height);
    
    [self addSubview:_titleLabel];
}
@end
