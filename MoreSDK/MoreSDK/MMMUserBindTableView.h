//
//  MMMUserBindTableView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMUserBindTableView : UITableView
@property (nonatomic, weak) id ownerDelegate;

-(void)setParams:(NSDictionary *)params;
@end
