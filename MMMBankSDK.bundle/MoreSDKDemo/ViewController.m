//
//  ViewController.m
//  MoreSDKDemo
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "ViewController.h"
#import "ControllerActivity.h"
#import "DataSigner.h"
#import "Base64Data.h"
#import "SecKeyWrapper.h"
#import "TimeUtil.h"
#import "ShowInfoTableViewController.h"
#import "PresentViewController.h"
#import "JSONKit.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *userReigsterBtn;
@property (weak, nonatomic) IBOutlet UIButton *loanBtn;
@property (weak, nonatomic) IBOutlet UIButton *withDrawBtn;
@property (weak, nonatomic) IBOutlet UIButton *authorizeBtn;
@property (weak, nonatomic) IBOutlet UIButton *transferBtn;



- (IBAction)userRegister:(id)sender;
- (IBAction)loan:(id)sender;
- (IBAction)withDraw:(id)sender;
- (IBAction)authorize:(id)sender;
- (IBAction)transfer:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

-(void)setStringValue:(NSString **)string {
    *string = @"hello";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userRegister:(id)sender {
    
    NSDictionary *postDic = @{@"Phone":@"1",
                              @"RegisterType":@"2",
                              @"Mobile":@"13732636231",
                              @"Email":@"7936440@qq.com",
                              @"RealName":@"金晨",
                              @"IdentificationNo":@"320586199107317810",
                              @"LoanPlatformAccount":@"sunshinek14",
                              @"PlatformMoneymoremore":@"p532",
                              @"Remark1":@"Remark1",
                              @"Remark2":@"Remark2",
                              @"Remark3":@"Remark3",
                              @"NotifyURL":@"http://localhost/testloanregisterbindnotify.action"} ;
    
    postDic = @{@"Phone":@"1",
                @"RegisterType":@"2",
                @"Mobile":@"13732635327",
                @"Email":@"793643579@qq.com",
                @"RealName":@"金晨",
                @"IdentificationNo":@"320586199107317810",
                @"LoanPlatformAccount":@"sunshinek5327",
                @"PlatformMoneymoremore":@"p532",
                @"Remark1":@"Remark1",
                @"Remark2":@"Remark2",
                @"Remark3":@"Remark3",
                @"NotifyURL":@"http://www.baidu.com"} ;
    
    postDic = @{@"Phone":@"1",
                @"RegisterType":@"2",

                @"Mobile":@"13220998888",
                @"Email":@"793643579@aaa.com",

                @"Mobile":@"13732653280",
                @"Email":@"793643579@aaaa.com",


                @"RealName":@"李科",
                @"IdentificationNo":@"430623198809291951",
                @"LoanPlatformAccount":@"U000024640",
                @"PlatformMoneymoremore":@"p1218",

                @"RealName":@"金晨",
                @"IdentificationNo":@"320586199107317810",
                @"LoanPlatformAccount":@"sunshinek53211",
                @"PlatformMoneymoremore":@"p532",

                @"Remark1":@"Remark1",
                @"Remark2":@"Remark2",
                @"Remark3":@"Remark3",
                @"NotifyURL":@"http://180.96.13.51:8006/client/handlerRegister.html"} ;
    
    postDic = @{@"Phone":@"1",
                @"RegisterType":@"2",
              @"Mobile":@"13611123761",
              @"RealName":@"陈捷",
              @"IdentificationNo":@"430623198809291951",
              @"LoanPlatformAccount":@"U000024653",
              @"PlatformMoneymoremore":@"p1218",
              @"NotifyURL":@"http://180.96.13.51:8006/client/doRegister.html"};
   //http://180.96.13.51:8006/client/handlerRegister.html
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"18602849762",
//                @"Email":@"jnmail@sina.com",
//                @"RealName":@"金晨",
//                @"IdentificationNo":@"211382748493738484",
//                @"LoanPlatformAccount":@"sunshinek192",
//                @"PlatformMoneymoremore":@"p196",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://www.baidu.com"} ;
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"13732637474",
//                @"Email":@"793643579@474.com",
//                @"RealName":@"金晨",
//                @"IdentificationNo":@"320586199107317810",
//                @"LoanPlatformAccount":@"sunshinek474",
//                @"PlatformMoneymoremore":@"p474",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanregisterbindnotify.action"} ;
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"18151100525",
////                @"Email":@"793643579@qq.com",
//                @"RealName":@"金晨",
//                @"IdentificationNo":@"320586199107317810",
//                @"LoanPlatformAccount":@"sunshinekp25",
//                @"PlatformMoneymoremore":@"p2",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanregisterbindnotify.action"} ;
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"13732637457",
//                @"Email":@"793643579@qq.com",
//                @"RealName":@"金晨",
//                @"IdentificationNo":@"320586199107317810",
//                @"LoanPlatformAccount":@"sunshinek457",
//                @"PlatformMoneymoremore":@"p457",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanregisterbindnotify.action"} ;
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"18662600525",
//                                @"Email":@"793643579@148.com",
//                @"RealName":@"金晨",
//                @"IdentificationNo":@"320586199107317810",
//                @"LoanPlatformAccount":@"sunshinekp148",
//                @"PlatformMoneymoremore":@"p148",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanregisterbindnotify.action"} ;
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"15298353127",
//                @"Email":@"793643579@q.com",
//                @"RealName":@"李建成",
//                @"IdentificationNo":@"110101198808087975",
//                @"LoanPlatformAccount":@"sunshinek11311",
//                @"PlatformMoneymoremore":@"p1131",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://www.baidu.com"} ;
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"13732637227",
//                @"Email":@"793643579@qq.com",
//                @"RealName":@"金晨",
//                @"IdentificationNo":@"320586199107317810",
//                @"LoanPlatformAccount":@"sunshinekp377",
//                @"PlatformMoneymoremore":@"p377",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://www.blp2p.cn/api/public/mmm/cashReturn.html"} ;
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMRegisterEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
}

- (IBAction)loan:(id)sender {
    
    
    NSDictionary *postDic = @{@"Phone":@"1",
                              @"RechargeMoneymoremore":@"m19616",
                              @"PlatformMoneymoremore":@"p532",
                              @"OrderNo":[TimeUtil getCurrentTime],
                              @"Amount":@"1.01",
                              @"RechargeType":@"2",
                              @"FeeType":@"1",
                              @"Remark1":@"Remark1",
                              @"Remark2":@"Remark2",
                              @"Remark3":@"Remark3",
                              @"NotifyURL":@"http://p2p.kingwins.com.cn/member/common/recharge?name=1&age=2"};
    


    //
    postDic = @{@"Phone":@"1",
                @"RechargeMoneymoremore":@"m42410",
                @"PlatformMoneymoremore":@"p1218",
                @"OrderNo":[TimeUtil getCurrentTime],
                @"Amount":@"5000.1",
                @"CardNo": @"",
                @"RechargeType":@"2",
                @"FeeType":@"1",
                @"Remark1":@"Remark1",
                @"Remark2":@"Remark2",
                @"Remark3":@"Remark3",
                @"NotifyURL":@"http://180.96.13.51:8006/userAccount/notifyRechargeResult.html"};
    
//    postDic = @{@"Phone":@"1",
//                 @"RechargeMoneymoremore":@"m31811",
//                 @"PlatformMoneymoremore":@"p1259",
//                 @"OrderNo":[TimeUtil getCurrentTime],
//                 @"Amount":@"500.01",
//                 @"RechargeType":@"2",
//                 @"FeeType":@"1",
//                 @"Remark1":@"Remark1",
//                 @"Remark2":@"Remark2",
//                 @"Remark3":@"Remark3",
//                 @"NotifyURL":@"http://p2p.kingwins.com.cn/member/common/recharge"};
    
//    postDic = @{@"Phone":@"1",
//                 @"RechargeMoneymoremore":@"m34681",
//                 @"PlatformMoneymoremore":@"p474",
//                 @"OrderNo":[TimeUtil getCurrentTime],
//                 @"Amount":@"1000",
//                 @"RechargeType":@"2",
//                 @"FeeType":@"1",
//                 @"Remark1":@"Remark1",
//                 @"Remark2":@"Remark2",
//                 @"Remark3":@"Remark3",
//                 @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};
//    
//    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m32756",
//                @"PlatformMoneymoremore":@"p474",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"200",
//                @"CardNo": @"",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};

    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m263272",
//                @"PlatformMoneymoremore":@"p293",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.01",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};
//    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m188502",
//                @"PlatformMoneymoremore":@"p293",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.01",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};
    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m18129",
//                @"PlatformMoneymoremore":@"p606",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"100.01",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};
//    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m200461",
//                @"PlatformMoneymoremore":@"p293",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.01",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};
//    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m102244",
//                @"PlatformMoneymoremore":@"p2",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.1",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};
//    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m102244",
//                @"PlatformMoneymoremore":@"p2",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.1",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"http://localhost/testloanrechargenotify.action"};
    
//    PresentViewController *daga = [[PresentViewController alloc]init];
//    [daga setparams:postDic event:MMMLoanEvent];
//    [self presentViewController:daga animated:YES completion:nil];
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMLoanEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
  
}

- (IBAction)withDraw:(id)sender {
    
    
    NSMutableDictionary *postDic = [@{@"phone":@"1",
                                      @"WithdrawMoneymoremore":@"m19616",
                                      @"PlatformMoneymoremore":@"p532",
                                      @"OrderNo":[TimeUtil getCurrentTime],
                                      @"Amount":@"1.01",
                                      @"FeePercent":@"0",
                                      @"CardNo":@"6217586101000298952",
                                      @"CardType":@"0",
                                      @"BankCode":@"1",
                                      @"Province":@"10",
                                      @"City":@"1078",
                                      @"NotifyURL":@"https://www.baidu.com"} mutableCopy];
    

//    {
//        Amount = 10;
//        BankCode = 28;
//        CardNo = 6222980027833971;
//        CardType = 0;
//        City = 1199;
//        FeePercent = 0;
//        NotifyURL = "http://180.96.13.51:8006/userAccount/withdrawReturn.html";
//        OrderNo = 20150630145231073;
//        PlatformMoneymoremore = p1218;
//        Province = 19;
//        WithdrawMoneymoremore = m42410;
//        phone = 1;
//    }

    postDic = [@{@"phone":@"1",
                 @"WithdrawMoneymoremore":@"m19616",
                 @"PlatformMoneymoremore":@"p532",
                 @"OrderNo":[TimeUtil getCurrentTime],
                 @"Amount":@"10",
                 @"FeePercent":@"0",
                 @"CardNo":@"6222021202013054078",
                 @"CardType":@"0",
                 @"BankCode":@"2",
                 @"Province":@"11",
                 @"City":@"1087",
                 @"NotifyURL":@"https://www.baidu.com"} mutableCopy];
    
//    postDic = [@{@"phone":@"1",
//                 @"WithdrawMoneymoremore":@"m42410",
//                 @"PlatformMoneymoremore":@"p1218",
//                 @"OrderNo":[TimeUtil getCurrentTime],
//                 @"Amount":@"10",
//                 @"FeePercent":@"0",
//                 @"CardNo":@"6222980027833971",
//                 @"CardType":@"0",
//                 @"BankCode":@"28",
//                 @"Province":@"19",
//                 @"City":@"1199",
//                 @"NotifyURL":@"https://www.baidu.com"} mutableCopy];

    
    postDic = [@{@"phone":@"1",
                 @"WithdrawMoneymoremore":@"m42410",
                 @"PlatformMoneymoremore":@"p1218",
                 @"OrderNo":[TimeUtil getCurrentTime],
                 @"Amount":@"10",
                 @"FeePercent":@"0",
                 @"CardNo":@"6222980027833971",
                 @"CardType":@"0",
                 @"BankCode":@"28",
                 @"Province":@"19",
                 @"City":@"1199",
                 @"NotifyURL":@"http://180.96.13.51:8006/userAccount/withdrawReturn.html"} mutableCopy];
    
//    postDic = [@{@"phone":@"1",
//                 @"WithdrawMoneymoremore":@"m102244",
//                 @"PlatformMoneymoremore":@"p2",
//                 @"OrderNo":[TimeUtil getCurrentTime],
//                 @"Amount":@"1.01",
//                 @"FeePercent":@"0",
//                 @"CardNo":@"6222021202013054078",
//                 @"CardType":@"0",
//                 @"BankCode":@"1",
//                 @"Province":@"11",
//                 @"City":@"1087",
//                 @"NotifyURL":@"http://www.baidu.com"} mutableCopy];
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMWithdrawEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
  
}

- (IBAction)authorize:(id)sender {
    
    NSMutableDictionary *postDic = [@{@"Phone":@"1",
                                      @"MoneymoremoreId":@"m19616",
                                      @"PlatformMoneymoremore":@"p532",
                                      @"AuthorizeTypeClose":@"1",
//                                       @"AuthorizeTypeClose":@"",
//                                      @"AuthorizeTypeOpen":@"1,2,3",
                                      @"NotifyURL":@"https://www.baidu.com"} mutableCopy];
//    postDic = [@{@"Phone":@"1",
//                                      @"MoneymoremoreId":@"m102244",
//                                      @"PlatformMoneymoremore":@"p2",
//                                      @"AuthorizeTypeClose":@"1",
//                                      //                                       @"AuthorizeTypeClose":@"",
//                                      //                                      @"AuthorizeTypeOpen":@"1,2,3",
//                                      @"NotifyURL":@"http://cs.guofud.com/api/public/mmm/loanAuthorizeReturn.html",
//                                      @"ReturnURL":@"http://cs.guofud.com/api/public/mmm/loanAuthorizeReturn.html"} mutableCopy];
    
    
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMAuthorizationEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
  
}

- (IBAction)transfer:(id)sender {
    
    NSDictionary *secondaryJsonList_1 = @{@"LoanInMoneymoremore":@"p457",
                                          @"Amount":@"100",
                                          @"FullAmount":@"300",
                                          @"TransferName":@"二次分配1",
                                          @"Remark":@"Remark"};
    
    NSArray *secondaryJsonListArr = @[secondaryJsonList_1
//                                      ,secondaryJsonList_2,secondaryJsonList_3
                                      ];
    
    
    
    NSString *secondaryJsonListString = [secondaryJsonListArr JSONString];
    /////////////////////////
    
    
    
    NSDictionary *loanJsonList_1 = @{@"LoanOutMoneymoremore":@"m19616",
                                     @"LoanInMoneymoremore":@"p532",
                                     @"OrderNo":[TimeUtil getCurrentTime],
                                     @"BatchNo":@"65000122123456",
                                     @"Amount":@"100",
                                     @"FullAmount":@"500000",
                                     @"TransferName":@"投标",
                                     @"Remark":@"Remark"
//                                     ,@"SecondaryJsonList":secondaryJsonListString
                                     };
//    loanJsonList_1 = @{@"LoanOutMoneymoremore":@"m102244",
//                       @"LoanInMoneymoremore":@"p2",
//                       @"OrderNo":[TimeUtil getCurrentTime],
//                       @"BatchNo":@"65000122123456",
//                       @"Amount":@"100",
//                       @"FullAmount":@"500000",
//                       @"TransferName":@"投标",
//                       @"Remark":@"Remark"
//                       //                                     ,@"SecondaryJsonList":secondaryJsonListString
//                       };
    
    NSArray *loanjsonListArr = @[
                                 loanJsonList_1
                                 ];
    
    
    
    NSString *loanJsonListString = [loanjsonListArr JSONString];
    
//    NSString *ttttt = [loanJsonList_1 JSONString];
    /////////////////////////
    NSMutableDictionary *postDic = [@{@"LoanJsonList":loanJsonListString,
                                      @"PlatformMoneymoremore":@"p532",
                                      @"TransferAction":@"1",
                                      @"Action":@"1",
                                      @"TransferType":@"2",
                                      @"NeedAudit":@"1",
//                                      @"Remark1":@"324",
//                                      @"Remark2":@"m3135",
//                                      @"Remark3":@"1",
                                      @"NotifyURL":@"https://www.baidu.com",
                                      @"Phone":@"1"} mutableCopy];
    
//    postDic = [@{@"LoanJsonList":loanJsonListString,
//                 @"PlatformMoneymoremore":@"p2",
//                 @"TransferAction":@"1",
//                 @"Action":@1,
//                 @"TransferType":@"2",
//                 @"NeedAudit":@"1",
//                 //                                      @"Remark1":@"324",
//                 //                                      @"Remark2":@"m3135",
//                 //                                      @"Remark3":@"1",
//                 @"NotifyURL":@"http://www.baidu.com",
//                 @"Phone":@"1"} mutableCopy];
    
    
//    NSLog(@"%@",postDic);
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMTransferEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    
}

- (IBAction)threeInOne:(UIButton *)sender {
    
    NSMutableDictionary *postDic = [@{@"phone":@"1",
                                      @"MoneymoremoreId":@"m19616",
                                      @"PlatformMoneymoremore":@"p532",
                                      @"Action":@"1",
                                      @"CardNo":@"",
                                      @"WithholdBeginDate":@"0",
                                      @"WithholdEndDate":@"6217586101000298952",
                                      @"SingleWithholdLimit":@"0",
                                      @"TotalWithholdLimit":@"1",
                                      @"RandomTimeStamp":@"10",
                                      @"Remark1":@"Remark1",
                                      @"Remark2":@"Remark2",
                                      @"Remark3":@"Remark3",
                                      @"NotifyURL":@"http://180.96.13.51:8006/userAccount/notifyRechargeResult.html"} mutableCopy];
    
    
    
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMThreeInOneEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];

}


#pragma mark - NSDIC transfer JSON
#pragma mark ----------
- (NSString*)stringByURLEncodingStringParameter:(NSString *)string
{
    // NSURL's stringByAddingPercentEscapesUsingEncoding: does not escape
    // some characters that should be escaped in URL parameters, like / and ?;
    // we'll use CFURL to force the encoding of those
    //
    // We'll explicitly leave spaces unescaped now, and replace them with +'s
    //
    // Reference: <a href="%5C%22http://www.ietf.org/rfc/rfc3986.txt%5C%22" target="\"_blank\"" onclick='\"return' checkurl(this)\"="" id="\"url_2\"">http://www.ietf.org/rfc/rfc3986.txt</a>
    
    NSString *resultStr = string;
    
    CFStringRef originalString = (__bridge CFStringRef) string;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}
@end
