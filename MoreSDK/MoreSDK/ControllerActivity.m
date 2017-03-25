//
//  ControllerActivity.m
//  mddDemo
//
//  Created by sunshinek31 on 15/1/8.
//  Copyright (c) 2015年 Jin Chen. All rights reserved.
//

#import "ControllerActivity.h"
#import "MMMBaseViewController.h"
#import "MMMRegisterController.h"
#import "MMMLoanController.h"
#import "MMMWithdrawController.h"
#import "MMMAuthorizeController.h"
#import "MMMTransferController.h"
#import "MMMToloanfastpayController.h"
#import "MMMConfigUtil.h"

@interface ControllerActivity ()
@property (nonatomic, strong) MMMBaseViewController *nextViewController;
@property (nonatomic, strong) UIWindow *overLayWindow;
@end

@implementation ControllerActivity


+(ControllerActivity *)share {
    static dispatch_once_t ControllerActivityOnce;
    static ControllerActivity *share;
    dispatch_once(&ControllerActivityOnce, ^{
        share = [[ControllerActivity alloc]init];
    });
    return share;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MMMBaseViewControllerRemove" object:nil];
    self.nextViewController = nil;
    self.overLayWindow = nil;
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeView:) name:@"MMMBaseViewControllerRemove" object:nil];
    }
    return self;
}

// 页面移除
-(void)removeView:(NSNotification *)notification {
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    keyWindow.hidden = NO;
    [[ControllerActivity share].overLayWindow makeKeyAndVisible];
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [ControllerActivity share].nextViewController.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
    } completion:^(BOOL finished) {
        
        [[ControllerActivity share].nextViewController.view removeFromSuperview];
        [ControllerActivity share].nextViewController.view = nil;
        [ControllerActivity share].overLayWindow.hidden = YES;
        [ControllerActivity share].overLayWindow.rootViewController = nil;
        [[ControllerActivity share].overLayWindow resignKeyWindow];
        [[ControllerActivity share].overLayWindow removeFromSuperview];
        [ControllerActivity share].overLayWindow = nil;
    }];
}


+(void)setServiceURL:(NSString *)serviceURL withEvent:(MMMEventType)event{
    [MMMConfigUtil sharedConfigUtil].setMainDomain(event, serviceURL);
}

+(void)setParams:(NSDictionary *)dic
           event:(MMMEventType)event
   signInfoBlock:(NSString *(^)(NSString *, BOOL))signBlock
     resultBlock:(void (^)(NSDictionary *, MMMEventType event ))resultBlock
{
    
    switch (event) {
        case MMMRegisterEvent:
            [ControllerActivity share].nextViewController = [[MMMRegisterController alloc]init];
            break;
        case MMMLoanEvent:
            [ControllerActivity share].nextViewController = [[MMMLoanController alloc]init];
            break;
        case MMMWithdrawEvent:
            [ControllerActivity share].nextViewController = [[MMMWithdrawController alloc]init];
            break;
        case MMMTransferEvent:
            [ControllerActivity share].nextViewController = [[MMMTransferController alloc]init];
            break;
        case MMMAuthorizationEvent:
            [ControllerActivity share].nextViewController = [[MMMAuthorizeController alloc]init];
            break;
        case MMMThreeInOneEvent:
            [ControllerActivity share].nextViewController = [[MMMToloanfastpayController alloc]init];
            break;
        default:
            [ControllerActivity share].nextViewController = [[MMMBaseViewController alloc]init];
            
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![ControllerActivity share].overLayWindow) {
            [ControllerActivity share].overLayWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
            [ControllerActivity share].overLayWindow.windowLevel = UIWindowLevelNormal;
            [ControllerActivity share].overLayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [ControllerActivity share].overLayWindow.rootViewController = [ControllerActivity share].nextViewController;
            [[ControllerActivity share].overLayWindow makeKeyAndVisible];
            [[ControllerActivity share].overLayWindow addSubview:[ControllerActivity share].nextViewController.view];
            [[ControllerActivity share].nextViewController setParams:dic signIfnoBlock:signBlock resultBlock:resultBlock];
            
            
            [ControllerActivity share].nextViewController.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [ControllerActivity share].nextViewController.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                [keyWindow setHidden:YES];
            }];
        }
        
    });
    
}

+(void)setParams:(NSDictionary *)dic
           event:(MMMEventType)event
   signInfoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock;
{
//    NSLog(@"%@",@"跳转");
    switch (event) {
        case MMMRegisterEvent:
            [ControllerActivity share].nextViewController = [[MMMRegisterController alloc]init];
            break;
        case MMMLoanEvent:
            [ControllerActivity share].nextViewController = [[MMMLoanController alloc]init];
            break;
        case MMMWithdrawEvent:
            [ControllerActivity share].nextViewController = [[MMMWithdrawController alloc]init];
            break;
        case MMMTransferEvent:
            [ControllerActivity share].nextViewController = [[MMMTransferController alloc]init];
            break;
        case MMMAuthorizationEvent:
            [ControllerActivity share].nextViewController = [[MMMAuthorizeController alloc]init];
            break;
        case MMMThreeInOneEvent:
            [ControllerActivity share].nextViewController = [[MMMToloanfastpayController alloc]init];
            break;
        default:
            [ControllerActivity share].nextViewController = [[MMMBaseViewController alloc]init];
            
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![ControllerActivity share].overLayWindow) {
            [ControllerActivity share].overLayWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
            
            [ControllerActivity share].overLayWindow.windowLevel = UIWindowLevelNormal;
            [ControllerActivity share].overLayWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [ControllerActivity share].overLayWindow.rootViewController = [ControllerActivity share].nextViewController;
            [[ControllerActivity share].overLayWindow makeKeyAndVisible];
            [[ControllerActivity share].overLayWindow addSubview:[ControllerActivity share].nextViewController.view];
            [[ControllerActivity share].nextViewController setParams:dic signIfnoBlock:signBlock];
            
            [ControllerActivity share].nextViewController.view.transform = CGAffineTransformMakeTranslation(0, [UIScreen mainScreen].bounds.size.height);
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [ControllerActivity share].nextViewController.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
                [keyWindow setHidden:YES];
        
            }];
        }
        
    });
    
}

+(void)enableTestServiceURL:(BOOL)isEnable {
    [MMMConfigUtil sharedConfigUtil].enableTestServiceURL(isEnable);
}

@end
