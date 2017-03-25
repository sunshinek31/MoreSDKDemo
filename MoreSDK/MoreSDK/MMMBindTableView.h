//
//  MMMBindTableView.h
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/27.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMBindTableView : UITableView
@property (nonatomic, weak) id ownerDelegate;

-(void)setParams:(NSDictionary *)params;
@end
