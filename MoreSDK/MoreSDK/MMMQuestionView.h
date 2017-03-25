//
//  MMMQuestionView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMMQuestionView : UIView
@property (nonatomic, strong) UILabel *questionTitleLabel;
@property (nonatomic, strong) UITextField *questionTitleTextField;
@property (nonatomic, strong) UILabel *answerTitleLabel;

@property (nonatomic, strong) UIButton *questionCustomBtn;

@property (nonatomic, copy, readonly) NSString *question;
@property (nonatomic, strong) UIButton *questionSwitchBtn;
@property (nonatomic, strong) UITextField *answerTextField;

-(void)setquestionTitle:(NSString *)title;
@end
