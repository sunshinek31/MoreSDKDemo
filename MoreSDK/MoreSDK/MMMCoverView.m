//
//  MMMCoverView.m
//  MoreSDK
//
//  Created by immortal on 15/7/20.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMCoverView.h"

@implementation MMMCoverView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self removeFromSuperview];
}
//- (instancetype)initWithFrame:(CGRect)frame{
//    
//    if (self = [super initWithFrame:frame]) {
//        
//        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
//        blurView.alpha = 1;
//        blurView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        [self addSubview:blurView];
//    }
//    return self;
//}
- (void) setBlur{
    
    if (self) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
                UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blur];
                blurView.alpha = 1;
                blurView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
                [self addSubview:blurView];
    }
}
@end
