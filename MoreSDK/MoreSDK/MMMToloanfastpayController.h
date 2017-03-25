//
//  MMMToloanfastpayViewController.h
//  MoreSDK
//
//  Created by immortal on 15/7/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBaseViewController.h"

@interface MMMToloanfastpayController : MMMBaseViewController
-(void)setParams:(NSDictionary *)params signIfnoBlock:(NSString *(^)(NSString *, BOOL))signBlock resultBlock:(void (^)(NSDictionary *, MMMEventType))resultBlock;

@end
