//
//  MMMBindInfoCell.h
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/28.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMBindInfoCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *registerNameTextField;
@property (nonatomic, strong) UITextField *certificateIDTextField;

-(void)setRegisterInfo:(NSString *)title
          registerName:(NSString *)registerName
         certificateID:(NSString *)certificateID;

-(void)setContentText:(NSString *)content;
@end
