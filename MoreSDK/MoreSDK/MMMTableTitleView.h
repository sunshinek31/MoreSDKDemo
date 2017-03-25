//
//  MMMTableTitleView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMTableTitleView : UIView
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;

-(void)setHeaderViewContentText:(NSString *)text andDetailContent:(NSString *)detailText;
@end
