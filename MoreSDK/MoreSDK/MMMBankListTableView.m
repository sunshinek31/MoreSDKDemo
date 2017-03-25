//
//  MMMBankListTableView.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/20.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBankListTableView.h"
#import "MMMBankObject.h"

@implementation MMMBankListTableView


-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self configViewStyle];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style bankList:(NSArray *)bankList{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.bankList = bankList;
        [self configViewStyle];
    }
    return self;
}

-(void)configViewStyle {
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.backgroundColor = [UIColor whiteColor];
    self.bounces = NO;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor colorWithRed:216.0f/255.0f green:221.0f/255.0f blue:227.0f/255.0f alpha:1].CGColor;
    self.layer.borderWidth = 0.5f;
    self.delegate = (id)self;
    self.dataSource = (id)self;
}

-(NSInteger)numberOfSections {
    return 1;
}

-(NSInteger)numberOfRowsInSection:(NSInteger)section {
    return _bankList.count;
}

-(UITableViewCell *)cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MDDBankListTableViewCellIdentifier = @"MDDBankListTableViewCellIdentifier";
    UITableViewCell *cell = [self dequeueReusableCellWithIdentifier:MDDBankListTableViewCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MDDBankListTableViewCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = @"";
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"MMMBankSDK" ofType:@"bundle"]];
    
    MMMBankObject *bankObject = [_bankList objectAtIndex:indexPath.row];
    NSString *alertImagePath = [bundle pathForResource:bankObject.BankCode ofType:@"png"];
    UIImage *img = [UIImage imageWithContentsOfFile:alertImagePath];
    if (img) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.backgroundView = imageView;
    }else{
        cell.textLabel.text = bankObject.BankName;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self numberOfRowsInSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MMMBankObject *bankObject = [_bankList objectAtIndex:indexPath.row];
    
    if (self.tapBlock) {
        self.tapBlock(indexPath,bankObject);
    }
}
@end
