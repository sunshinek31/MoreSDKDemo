//
//  MMMSendMessageView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/17.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMSendMessageView : UIView
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *sendMsgBtn;

-(void)sendMessageBtnPressed:(BOOL(^)())optionBlock;
@end
