//
//  ControllerActivity.h
//  mddDemo
//
//  Created by sunshinek31 on 15/1/8.
//  Copyright (c) 2015年 Jin Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMEventEnum.h"

@interface ControllerActivity : NSObject

/** 乾多多测试服务器调试模式
 *  @param isEnable 默认服务器开关
 *                  当isEnable=YES时,启用测试服务器(http://218.4.234.150:88/main)
 *                  当isEnable=NO时,启用正式服务器(https://www.moneymoremore.com)
 *
 *  注意:当未使用该方法时, 默认启用正式服务器
 */
+(void)enableTestServiceURL:(BOOL)isEnable;

/** 自定义服务器
 *  @param serviceURL 用户自定义的服务器地址
 *                    (如将来默认测试服务器或正式服务器发生变动,用该方法临时配置)
 *
 *  注意:没有特殊情况, 不建议使用该方法
 */
+(void)setServiceURL:(NSString *)serviceURL withEvent:(MMMEventType)event;

/** 乾多多接口调用
 *  @param dic 用户提供的NSDictionary数据
 *  @param event 用户需要选择的事件:
 *               MMMRegisterEvent-开户,
 *               MMMLoanEvent-充值,
 *               MMMWithdrawEvent-提现,
 *               MMMAuthorizationEvent-授权,
 *               MMMTransferEvent-转账
 *  @param signBlock 用户签名或加密字符串block:
 *         block的参数中signInfo是需要用户进行处理的字符串数据,isSignWithPrivateKey用来判断签名或者加密
 *         当isSignWithPrivateKey=YES时,用户需要对signInfo做私钥签名处理,
 *         当isSignWithPrivateKey=NO时,用户需要对signInfo做公钥加密处理
 */
+(void)setParams:(NSDictionary *)dic
           event:(MMMEventType)event
   signInfoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock;

/** 乾多多接口调用
 *  @param dic 用户提供的NSDictionary数据
 *  @param event 用户需要选择的事件:
 *               MMMRegisterEvent-开户,
 *               MMMLoanEvent-充值,
 *               MMMWithdrawEvent-提现,
 *               MMMAuthorizationEvent-授权,
 *               MMMTransferEvent-转账
 *  @param signBlock 用户签名或加密字符串block:
 *         block的参数中signInfo是需要用户进行处理的字符串数据,isSignWithPrivateKey用来判断签名或者加密
 *         当isSignWithPrivateKey=YES时,用户需要对signInfo做私钥签名处理,
 *         当isSignWithPrivateKey=NO时,用户需要对signInfo做公钥加密处理
 *  @param resultBlock 用户事件回调block,返回目标事件的数据结果
 *         (如用户进行充值事件时,当用户点击充值按钮并从服务器成功返回数据后,执行该block.
 *         用户可根据block提供的NSdictionary参数,自行进行下一步结果处理)
 */
+(void)setParams:(NSDictionary *)dic
           event:(MMMEventType)event
   signInfoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock
     resultBlock:(void (^)(NSDictionary *result, MMMEventType event))resultBlock;

@end
