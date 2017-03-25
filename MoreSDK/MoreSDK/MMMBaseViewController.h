//
//  MMMBaseViewController.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MMMEventEnum.h"
#import <objc/message.h> 
#import "MMMActivityIndicatorView.h"

typedef NSString*(^SignInfoBlock)(NSString *signInfo, BOOL isSignWithPrivateKey);
typedef void (^ResultBlock)(NSDictionary *result, MMMEventType event);
typedef void (^SimpleBlock)();

@interface MMMBaseViewController : UIViewController
{
@protected
    NSMutableDictionary *_signDataDic;
    
}
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) SignInfoBlock signInfoBlock;
@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, weak) id viewControllDelegate;
@property (nonatomic, strong) UIAlertView *theAlert;

-(void)setVCDelegate:(id)VCDelegate;

-(id)initWithFrame:(CGRect) frame;


//赋值方法, 传递参数
-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock;

-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock
     resultBlock:(void (^)(NSDictionary *result, MMMEventType event))resultBlock;

-(void)back:(id)sender ;
-(BOOL)checkNecessaryParams:(const char *)className tagertObj:(id)obj;

//数据回调方法
//-(void)sendRequestByURL:(NSString *)URTString
//             signString:(NSString *)signDataStr
//                dataDic:(NSDictionary *)params
//               eventTag:(NSUInteger)tag;
-(void)callBackOfRequest:(NSData *)data withTag:(NSUInteger)tag;
-(void)errorOfCallBack:(NSError *)error;
@end
