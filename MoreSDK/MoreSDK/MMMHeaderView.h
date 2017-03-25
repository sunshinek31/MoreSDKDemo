//
//  MMMHeaderView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMHeaderView : UIView
@property (nonatomic, strong) UILabel *headerLabel_1;
@property (nonatomic, strong) UILabel *headerLabel_2;
@property (nonatomic, strong) UILabel *headerLabel_3;

-(id)initWithFrame:(CGRect)frame andNumOfLabel:(NSUInteger)num;

-(void)setContext:(NSString *)labeltext1
     headerLabel2:(NSString *)labeltext2
      hederLabel3:(NSString *)labeltext3;
@end
