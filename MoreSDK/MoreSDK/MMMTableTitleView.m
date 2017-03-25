//
//  MMMTableTitleView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMTableTitleView.h"

@implementation MMMTableTitleView
{
@private
    UIView *_lableBackView;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50);
    }
    return self;
}

-(void)setHeaderViewContentText:(NSString *)text andDetailContent:(NSString *)detailText {
    
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 50)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    if (!_detailTextLabel) {
        _detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 50)];
        _detailTextLabel.font = [UIFont systemFontOfSize:12];
        _detailTextLabel.textColor = [UIColor darkGrayColor];
        _detailTextLabel.backgroundColor =[UIColor clearColor];
    }
    
    if (!_lableBackView) {
        _lableBackView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, 100, 50)];
        _lableBackView.backgroundColor = [UIColor whiteColor];
        _lableBackView.backgroundColor = self.backgroundColor;
        [self addSubview:_lableBackView];
    }
    
    _textLabel.text = [NSString stringWithFormat:@"%@",text];
    _detailTextLabel.text = [NSString stringWithFormat:@"(%@)",detailText];
    
    [_textLabel sizeToFit];
    [_detailTextLabel sizeToFit];
    
    CGRect frame_textLabel = _textLabel.frame;
    CGRect frame_detailTextLabel = _detailTextLabel.frame;
    
    
    _detailTextLabel.frame = CGRectMake(frame_textLabel.size.width+4, 0, frame_detailTextLabel.size.width, 50);
    _textLabel.frame = CGRectMake(2, 0, frame_textLabel.size.width, 50);
    _lableBackView.frame = CGRectMake(10, 0, frame_textLabel.size.width+frame_detailTextLabel.size.width+6, 50);
    
    
    [_lableBackView addSubview:_textLabel];
    [_lableBackView addSubview:_detailTextLabel];
}

-(void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 0.3);
    CGContextSetRGBStrokeColor(context, 192.0f/255.0f, 192.0f/255.0f, 192.0f/255.0f, 1.0);
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, self.frame.size.height/2);
    CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height/2);
    
    CGContextStrokePath(context);
    
    _lableBackView.backgroundColor = self.backgroundColor;
}
@end
