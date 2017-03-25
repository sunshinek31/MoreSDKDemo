//
//  MMMRegisterScrollView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMEventEnum.h"

typedef void(^ResultBlock)(NSDictionary *result, MMMEventType event);
typedef void(^CompleteBlock)();

@interface MMMRegisterScrollView : UIScrollView
@property (nonatomic, assign) BOOL isShowEmail; //在setParams:方法前赋值
@property (nonatomic, copy) ResultBlock resultBlock;
@property (nonatomic, copy) CompleteBlock completeBlock;

-(void)setParams:(NSDictionary *)params;
@end
