//
//  MMMOptionTableView.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MMMOptionTableViewDelegate ;

@interface MMMOptionTableView : UITableView

-(id)initWithFrame:(CGRect)frame
             style:(UITableViewStyle)style
            params:(NSArray *)params;

-(void)didSelectIndexPath:(void(^)(NSIndexPath *indexPath,NSString *context,NSInteger tag))didSelectBlock;
@end


