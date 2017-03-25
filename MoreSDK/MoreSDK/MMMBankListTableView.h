//
//  MMMBankListTableView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/20.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMMBankObject;
typedef void(^DidSelectIndexPathBlock)(NSIndexPath *indexPath, id object);

@interface MMMBankListTableView : UITableView

@property (nonatomic ,strong) NSArray *bankList;
@property (nonatomic ,copy) DidSelectIndexPathBlock tapBlock;
-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style bankList:(NSArray *)bankList;
@end

