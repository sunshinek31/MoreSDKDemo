//
//  MMMBankListViewController.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/3/3.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBaseViewController.h"
@class MMMBankObject;

typedef void(^DidSelectBlock)(NSIndexPath *,MMMBankObject * );

//@protocol MMMBankListViewControllerDelegate ;

@interface MMMBankListViewController : MMMBaseViewController
//@property (nonatomic, weak) id<MMMBankListViewControllerDelegate> chooseBankDelegate;
-(void) setupBankListData:(NSArray *)bankList;
-(void) setupBankListData:(NSArray *)bankList currentBankObj:(MMMBankObject *)currentBank;

-(void) didSelectIndexPath:(DidSelectBlock )didSelectBlock;
@end

//@protocol MMMBankListViewControllerDelegate <NSObject>
//
//-(void)didSelectIndexPath:(NSIndexPath *)indexPath selectedBankObj:(MMMBankObject *)bankObj;
//
//@end