//
//  MMMHeaderView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMHeaderView.h"

@implementation MMMHeaderView
{
    float _height;
}

-(id)initWithFrame:(CGRect)frame andNumOfLabel:(NSUInteger)num {
    self = [super initWithFrame:frame];
    if (self) {
        _height = self.frame.size.height/num;
    }
    return self;
}

-(void)setContext:(NSString *)labeltext1
     headerLabel2:(NSString *)labeltext2
      hederLabel3:(NSString *)labeltext3
{
    UIColor *color = [UIColor colorWithRed:100.0f/255.0f green:149.0f/255.0f blue:237.0f/255.0f alpha:1];
    
    float height = _height;
    float width = self.frame.size.width - 20;
    if (!_headerLabel_1) {
        _headerLabel_1 = [[UILabel alloc]initWithFrame:CGRectMake(10,0, width, height)];
        _headerLabel_1.textAlignment = NSTextAlignmentLeft;
        _headerLabel_1.font = [UIFont systemFontOfSize:16];
        _headerLabel_1.textColor = color;
        _headerLabel_1.text = labeltext1;
        [self addSubview:_headerLabel_1];
    }
    
    if (!_headerLabel_2) {
        _headerLabel_2 = [[UILabel alloc]initWithFrame:CGRectMake(10,height, width, height)];
        _headerLabel_2.textAlignment = NSTextAlignmentLeft;
        _headerLabel_2.font = [UIFont systemFontOfSize:16];
        _headerLabel_2.textColor = color;
        _headerLabel_2.text = labeltext2;
        [self addSubview:_headerLabel_2];
    }
    
    if (!_headerLabel_3) {
        _headerLabel_3 = [[UILabel alloc]initWithFrame:CGRectMake(10,height*2, width, height)];
        _headerLabel_3.textAlignment = NSTextAlignmentLeft;
        _headerLabel_3.font = [UIFont systemFontOfSize:16];
        _headerLabel_3.textColor = color;
        _headerLabel_3.text = labeltext3;
        [self addSubview:_headerLabel_3];
    }
}
@end
