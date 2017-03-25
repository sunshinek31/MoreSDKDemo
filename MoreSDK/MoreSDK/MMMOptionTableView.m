//
//  MMMOptionTableView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMOptionTableView.h"

typedef void(^DidSelectedIndexPathBlock)(NSIndexPath *,NSString *,NSInteger);

@interface MMMOptionTableView ()
<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) DidSelectedIndexPathBlock didSelectedBlock;
@end

@implementation MMMOptionTableView
{
@private
    NSArray *_cellArr;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style params:(NSArray *)params {
    self = [self initWithFrame:frame style:style];
    if (self) {
        _cellArr = [NSArray arrayWithArray:params];
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* MDDOptionTableViewCellIdentifier = @"MDDOptionTableViewCellIdentifier";
    UITableViewCell *cell;
    cell = [self dequeueReusableCellWithIdentifier:MDDOptionTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MDDOptionTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _cellArr[indexPath.row];
    return cell;
}

-(UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* MDDOptionTableViewCellIdentifier = @"MDDOptionTableViewCellIdentifier";
    UITableViewCell *cell;
    cell = [self dequeueReusableCellWithIdentifier:MDDOptionTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MDDOptionTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _cellArr[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *context = _cellArr[indexPath.row];
    if (indexPath.row == 0) {
        context = nil;
    }
    
    if (self.didSelectedBlock) {
        self.didSelectedBlock(indexPath, context, self.tag);
    }
}

-(void)didSelectIndexPath:(void (^)(NSIndexPath *, NSString *, NSInteger))didSelectBlock {
    _didSelectedBlock = [didSelectBlock copy];
}
@end
