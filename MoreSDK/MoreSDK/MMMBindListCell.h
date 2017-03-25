//
//  MMMBindListCell.h
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/28.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMBindListCell : UITableViewCell
@property (nonatomic, strong) UILabel *label_1;
@property (nonatomic, strong) UILabel *label_2;

-(void)setTitle:(NSString *)account1
       account2:(NSString *)account2
       realName:(NSString *)name
   identifierId:(NSString *)identifierId;
@end
