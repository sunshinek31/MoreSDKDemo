//
//  MMMBankListViewController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/3/3.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBankListViewController.h"
#import "MMMBankObject.h"
#import "MMMSingleInputCell.h"

@interface MMMBankListViewController ()
@property (nonatomic, strong) NSArray *bankList;
@property (nonatomic, strong) MMMBankObject *currentBankObj;
@property (nonatomic) NSIndexPath *selectedIndexPath;
@property (nonatomic, weak) UITableView *currentTableView;

@property (nonatomic, copy) DidSelectBlock didSelectBlock;

//@property (nonatomic, strong) UITableView *currentTableView;
@end

@implementation MMMBankListViewController

-(id)init{
    self = [super init];
    if (self) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width) style:UITableViewStyleGrouped];
        tableView.delegate = (id)self;
        tableView.dataSource = (id)self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _currentTableView = tableView;
        
        [self.contentView addSubview: tableView];
        
        UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
        UIBarButtonItem *none = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(confirm:)];
        [self.toolbar setItems:@[leftBtnItem,none,rightBtnItem]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didSelectIndexPath:(DidSelectBlock)didSelectBlock {
    self.didSelectBlock = [didSelectBlock copy];
    
}

-(void)confirm:(UIBarButtonItem *)sender {
    if (self.didSelectBlock) {
        self.didSelectBlock(_selectedIndexPath,_currentBankObj);
        [self back:nil];
    }
}

-(void)setupBankListData:(NSArray *)bankList{
    _bankList = [bankList copy];
}

-(void)setupBankListData:(NSArray *)bankList currentBankObj:(MMMBankObject *)currentBank {
    _bankList = bankList;
    _currentBankObj = currentBank;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bankList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MMMSingleInputCellIdentifier = @"MMMSingleInputCellIdentifier";
    static NSString *MMMBankListViewControllerCellIdentifier = @"MMMBankListViewControllerCellIdentifier";
    
    MMMSingleInputCell *singleInputCell;
    singleInputCell = [tableView dequeueReusableCellWithIdentifier:MMMSingleInputCellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MMMBankListViewControllerCellIdentifier];
    
    singleInputCell = [[MMMSingleInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MMMSingleInputCellIdentifier];
    singleInputCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MMMBankListViewControllerCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    MMMBankObject *bankObj = [_bankList objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = nil;
    [singleInputCell setTitleContent:[NSString stringWithFormat:@"%@ 尾号(%@)",bankObj.BankName,bankObj.TailNo]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ 尾号(%@)",bankObj.BankName,bankObj.TailNo];
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell.frame.size.height)];
    backgroundView.backgroundColor = [UIColor clearColor];
    UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, backgroundView.frame.size.width-20, backgroundView.frame.size.height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:whiteView];
    
    whiteView.layer.masksToBounds = YES;
//    whiteView.layer.borderColor = self.tableView.backgroundColor.CGColor;
    whiteView.layer.borderColor = self.contentView.backgroundColor.CGColor;
    whiteView.layer.borderWidth = 0.5f;
    
    cell.backgroundView = backgroundView;
    
    if (_currentBankObj && _currentBankObj.CardNo == bankObj.CardNo) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentBankObj = [_bankList objectAtIndex:indexPath.row];
    _selectedIndexPath = indexPath;
    [tableView reloadData];
}

-(void)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
