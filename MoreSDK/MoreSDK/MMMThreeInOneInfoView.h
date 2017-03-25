//
//  MMMThreeInOneInfoView.h
//  MoreSDK
//
//  Created by immortal on 15/7/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ScSize [UIScreen mainScreen].bounds.size
@interface MMMThreeInOneInfoView : UIImageView
+ (MMMThreeInOneInfoView *)infoViewWithInfos:(NSDictionary *)dic;
@end
