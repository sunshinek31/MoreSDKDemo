//
//  MMMSingleInputCell.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSingleInputCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;

-(void)setTitleContent:(NSString *)titleContent andDetailContent:(NSString *)detailContent;
-(void)setTitleContent:(NSString *)titleContent;
@end
