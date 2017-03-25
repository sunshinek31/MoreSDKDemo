//
//  ShowInfoTableViewController.h
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/28.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMEventEnum.h"

@interface ShowInfoTableViewController : UITableViewController

-(void)setparams:(NSDictionary *)params event:(MMMEventType)enent;
@end
