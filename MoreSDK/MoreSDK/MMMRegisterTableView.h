//
//  MMMRegisterTableView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteBlock)();

@interface MMMRegisterTableView : UITableView
@property (nonatomic, weak) id ownerDelegate;
@property (nonatomic, assign) BOOL isShowEmail;         //显示邮箱输入label
@property (nonatomic, assign) CompleteBlock completeBlock;
-(void)setParams:(NSDictionary *)params;

-(void)RA:(NSDictionary *)params;
@end
