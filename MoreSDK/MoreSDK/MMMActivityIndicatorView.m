//
//  MMMActivityIndicatorView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/5/21.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMActivityIndicatorView.h"

@interface MMMActivityIndicatorView ()

@property (nonatomic, strong) UIWindow *overlayWindow;
@property (nonatomic, strong) UIActivityIndicatorView *spinnerView;
@property (nonatomic, strong) UIView *hudView;
@end

@implementation MMMActivityIndicatorView

+(MMMActivityIndicatorView *)shareView {
    static dispatch_once_t once;
    static MMMActivityIndicatorView *shareView;
    
    dispatch_once(&once, ^{
        shareView = [[MMMActivityIndicatorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return shareView;
}

+(void)show {
    [[MMMActivityIndicatorView shareView] showActivityIndicatorView];
}

-(void)showActivityIndicatorView {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.superview) {

            [self.overlayWindow addSubview:self];
            [self.spinnerView startAnimating];
            self.alpha = 1.0;
            [self.overlayWindow makeKeyAndVisible];
        }
        
        [self setNeedsDisplay];
    });
    
}

+(void)remove {
    [[MMMActivityIndicatorView shareView] dismiss];
}
-(void)dismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
                             self.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             if(self.alpha == 0) {
                                 [_hudView removeFromSuperview];
                                 [self removeFromSuperview];
                                 _hudView = nil;
                                 
                                 // Make sure to remove the overlay window from the list of windows
                                 // before trying to find the key window in that same list
                                 NSMutableArray *windows = [[NSMutableArray alloc] initWithArray:[UIApplication sharedApplication].windows];
                                 [windows removeObject:_overlayWindow];
                                 _overlayWindow = nil;
                                 
                                 [windows enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIWindow *window, NSUInteger idx, BOOL *stop) {
                                     if([window isKindOfClass:[UIWindow class]] && window.windowLevel == UIWindowLevelNormal) {
                                         [window makeKeyWindow];
                                         *stop = YES;
                                     }
                                 }];
                                 
                             }
                         }];
    });
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Getters

- (UIWindow *)overlayWindow {
    if(!_overlayWindow) {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.windowLevel = UIWindowLevelAlert;
        _overlayWindow.backgroundColor = [UIColor clearColor];
        _overlayWindow.userInteractionEnabled = NO;
    }
    return _overlayWindow;
}
- (UIActivityIndicatorView *)spinnerView {
    if (_spinnerView == nil) {
        _spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinnerView.hidesWhenStopped = YES;
        _spinnerView.bounds = CGRectMake(0, 0, 37, 37);
    }
    
    if(!_spinnerView.superview) {
        
        [self.hudView addSubview:_spinnerView];
        _spinnerView.center = CGPointMake(_hudView.frame.size.width/2, _hudView.frame.size.height/2);
        
        
    }
    
    
    return _spinnerView;
}
- (UIView *)hudView {
    if(!_hudView) {
        _hudView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        
                _hudView.center = self.center;
        _hudView.layer.cornerRadius = 10;
        _hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _hudView.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin);
        
        [self addSubview:_hudView];
    
    }
    return _hudView;
}
@end
