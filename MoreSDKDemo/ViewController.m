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
                @"Mobile":@"13732637227",
//                @"Email":@"793643579@qq.com",
                @"RealName":@"金晨",
                @"IdentificationNo":@"320586199107317810",
                @"LoanPlatformAccount":@"sunshinek532",
                @"PlatformMoneymoremore":@"p532",
                @"Remark1":@"Remark1",
                @"Remark2":@"Remark2",
                @"Remark3":@"Remark3",
                @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"} ;
    
//    postDic = @{@"Phone":@"1",
//                @"RegisterType":@"2",
//                @"Mobile":@"13732637227",
////                @"Email":@"793643579@qq.com",
//                @"RealName":@"金晨",
//                @"IdentificationNo":@"320586199107317810",
//                @"LoanPlatformAccount":@"sunshinek467_1",
//                @"PlatformMoneymoremore":@"p467",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"} ;
    
    postDic = @{@"Phone":@"1",
                @"RegisterType":@"2",
                @"Mobile":@"13732637291",
                //                @"Email":@"793643579@qq.com",
                @"RealName":@"金晨",
                @"IdentificationNo":@"320586199107317810",
                @"LoanPlatformAccount":@"sunshinek291",
                @"PlatformMoneymoremore":@"p291",
                @"RandomTimeStamp":@"",
                @"Remark1":@"Remark1",
                @"Remark2":@"Remark2",
                @"Remark3":@"Remark3",
                @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"} ;

    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMRegisterEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
}

- (IBAction)loan:(id)sender {
    
    
    NSDictionary *postDic = @{@"Phone":@"1",
                              @"RechargeMoneymoremore":@"m55078",
                              @"PlatformMoneymoremore":@"p532",
                              @"OrderNo":[TimeUtil getCurrentTime],
                              @"Amount":@"50.01",
                              @"RechargeType":@"2",
                              @"FeeType":@"2",
                              @"Remark1":@"Remark1",
                              @"Remark2":@"Remark2",
                              @"Remark3":@"Remark3",
                              @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"};
    

    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m789071",
//                @"PlatformMoneymoremore":@"p467",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.1",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"};
//    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m785991",
//                @"PlatformMoneymoremore":@"p467",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.1",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"};
    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m404164",
//                @"PlatformMoneymoremore":@"p503",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.1",
//                @"RechargeType":@"2",
//                @"FeeType":@"1",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"};
 
//    postDic = @{@"Phone":@"1",
//                              @"RechargeMoneymoremore":@"m818200",
//                              @"PlatformMoneymoremore":@"p291",
//                              @"OrderNo":@"20151012140953829",
//                              @"Amount":@"1.1",
//                              @"RechargeType":@"2",
//                              @"FeeType":@"1",
//                              @"RandomTimeStamp":[NSString stringWithFormat:@"21%@",[TimeUtil getCurrentTime]],
//                              @"Remark1":@"Remark1",
//                              @"Remark2":@"Remark2",
//                              @"Remark3":@"Remark3",
//                              @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"};
    
//    postDic = @{@"Phone":@"1",
//                @"RechargeMoneymoremore":@"m102244",
//                @"PlatformMoneymoremore":@"p2",
//                @"OrderNo":[TimeUtil getCurrentTime],
//                @"Amount":@"1.01",
//                @"RechargeType":@"2",
//                @"FeeType":@"2",
//                @"Remark1":@"Remark1",
//                @"Remark2":@"Remark2",
//                @"Remark3":@"Remark3",
//                @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"};
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMLoanEvent];
        [self.navigationController pushViewController:nextViewController animated:YES];
    
//    PresentViewController *pview = [[PresentViewController alloc]init];
//    [pview setparams:postDic event:MMMLoanEvent];
//    [self presentViewController:pview animated:YES completion:nil];
    
  
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
                                      @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"} mutableCopy];
    

    postDic = [@{@"phone":@"1",
                 @"WithdrawMoneymoremore":@"m102244",
                 @"PlatformMoneymoremore":@"p2",
                 @"OrderNo":[TimeUtil getCurrentTime],
                 @"Amount":@"1.01",
                 @"FeePercent":@"0",
                 @"CardNo":@"6217586101000298952",
                 @"CardType":@"0",
                 @"BankCode":@"48",
                 @"Province":@"11",
                 @"City":@"1087",
                 @"NotifyURL":@"https://www.baidu.com"} mutableCopy];
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMWithdrawEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
  
}

- (IBAction)authorize:(id)sender {
    
    NSMutableDictionary *postDic = [@{@"Phone":@"1",
                                      @"MoneymoremoreId":@"m19616",
                                      @"PlatformMoneymoremore":@"p532",
                                      @"AuthorizeTypeClose":@"1",
//                                      @"AuthorizeTypeOpen":@"1,2,3",
                                      @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action"} mutableCopy];
    
    
    
    
    
//    postDic = [@{@"Phone":@"1",
//                                      @"MoneymoremoreId":@"m102244",
//                                      @"PlatformMoneymoremore":@"p2",
//                                      @"AuthorizeTypeClose":@"1",
//                                      //                                       @"AuthorizeTypeClose":@"",
//                                      //                                      @"AuthorizeTypeOpen":@"1,2,3",
//                                      @"NotifyURL":@"http://cs.guofud.com/api/public/mmm/loanAuthorizeReturn.html",
//                                      @"ReturnURL":@"http://cs.guofud.com/api/public/mmm/loanAuthorizeReturn.html"} mutableCopy];
    
    postDic = [@{@"Phone":@"1",
                  @"MoneymoremoreId":@"m50937",
                  @"PlatformMoneymoremore":@"p1141",
                  @"AuthorizeTypeClose":@"2,3",
                  //                                       @"AuthorizeTypeClose":@"",
                  //                                      @"AuthorizeTypeOpen":@"1,2,3",
                  @"NotifyURL":@"http://61.185.204.112:8093/pay/shuangqian/authorizeNotify.htm"} mutableCopy];
    
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMAuthorizationEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
  
}

- (IBAction)transfer:(id)sender {
    
    NSDictionary *secondaryJsonList_1 = @{@"LoanInMoneymoremore":@"p532",
                                          @"Amount":@"100",
                                          @"FullAmount":@"300",
                                          @"TransferName":@"二次分配1",
                                          @"Remark":@"Remark"};
    
    NSArray *secondaryJsonListArr = @[secondaryJsonList_1
//                                      ,secondaryJsonList_2,secondaryJsonList_3
                                      ];
    
    
    
    NSString *secondaryJsonListString = [secondaryJsonListArr JSONString];
    /////////////////////////
    
    
    
    NSDictionary *loanJsonList_1 = @{@"LoanOutMoneymoremore":@"m55078",
                                     @"LoanInMoneymoremore":@"p532",
                                     @"OrderNo":[TimeUtil getCurrentTime],
                                     @"BatchNo":@"65000122123456",
                                     @"Amount":@"100",
                                     @"FullAmount":@"500000",
                                     @"TransferName":@"投标",
                                     @"Remark":@"Remark"
//                                     ,@"SecondaryJsonList":secondaryJsonListString
                                     };
    
    
    loanJsonList_1 = @{@"LoanOutMoneymoremore":@"m102244",
                       @"LoanInMoneymoremore":@"p2",
                       @"OrderNo":[TimeUtil getCurrentTime],
                       @"BatchNo":@"65000122123456",
                       @"Amount":@"100",
                       @"FullAmount":@"500000",
                       @"TransferName":@"投标",
                       @"Remark":@"Remark"
                       //                                     ,@"SecondaryJsonList":secondaryJsonListString
                       };
    
    NSArray *loanjsonListArr = @[
                                 loanJsonList_1
//                                 ,loanJsonList_2
//                                 ,loanJsonList_3
//                                 ,loanJsonList_4
//                                 ,loanJsonList_5
//                                 ,loanJsonList_6
//                                 ,loanJsonList_7
//                                 ,loanJsonList_8
//                                 ,loanJsonList_9
                                 ];
    
    
    
    NSString *loanJsonListString = [loanjsonListArr JSONString];
//    loanJsonListString = [self stringByURLEncodingStringParameter:loanJsonListString];
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
                                      @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action",
                                      @"Phone":@"1"} mutableCopy];
    
    postDic = [@{@"LoanJsonList":loanJsonListString,
                 @"PlatformMoneymoremore":@"p2",
                 @"TransferAction":@"1",
                 @"Action":@"1",
                 @"TransferType":@"2",
                 @"NeedAudit":@"1",
                 //                                      @"Remark1":@"324",
                 //                                      @"Remark2":@"m3135",
                 //                                      @"Remark3":@"1",
                 @"NotifyURL":@"https://www.moneymoremore.com/loan/testloanwithdrawsreturn.action",
                 @"Phone":@"1"} mutableCopy];

    
    NSLog(@"%@",postDic);
    ShowInfoTableViewController *nextViewController = [[ShowInfoTableViewController alloc]initWithStyle:UITableViewStylePlain];
    [nextViewController setparams:postDic event:MMMTransferEvent];
    [self.navigationController pushViewController:nextViewController animated:YES];
    
    
}
//AccountNumber = 1863179;
//Message = "\U6210\U529f";
//MoneymoremoreId = m44890;我的亁多多号
- (IBAction)threeInOne:(UIButton *)sender {
    
    NSMutableDictionary *postDic = [@{@"Phone":@"1",
                                      @"MoneymoremoreId":@"m44890",
                                      @"PlatformMoneymoremore":@"p532",

                                      @"Action":@"2",
                                      @"CardNo":@"6217002000022659116",//
                                     // @"CardType":@"0",
                                     // @"BankCode":@"1",
                                     // @"BranchBankName":@"农",
//                                      @"Province":@"1",
//                                      @"City":@"1001",
//
//                                      @"Action":@"1",
//                                      @"CardNo":@"",

                                      @"WithholdBeginDate":@"",
                                      @"WithholdEndDate":@"",
                                      @"SingleWithholdLimit":@"",
                                      @"TotalWithholdLimit":@"",
                                      @"RandomTimeStamp":@"",
                                      @"Remark1":@"Remark1",
                                      @"Remark2":@"Remark2",
                                      @"Remark3":@"Remark3",
                                      @"NotifyURL":@"http://180.96.13.51:8006/userAccount/notifyRechargeResult.html"} mutableCopy];
    
    postDic = [@{@"phone":@"1",
                 @"MoneymoremoreId":@"m19616",
                 @"PlatformMoneymoremore":@"p532",
                 @"Action":@"2",
                 @"CardNo":@"62175861010002989552",
                 @"WithholdBeginDate":@"",
                 @"WithholdEndDate":@"",
                 @"SingleWithholdLimit":@"",
                 @"TotalWithholdLimit":@"",
                 @"RandomTimeStamp":@"",
                 @"Remark1":@"Remark1",
                 @"Remark2":@"Remark2",
                 @"Remark3":@"Remark3",
                 @"NotifyURL":@"http://180.96.13.51:8006/userAccount/notifyRechargeResult.html"} mutableCopy];
    
    postDic = [@{@"phone":@"1",
                 @"MoneymoremoreId":@"m102244",
                 @"PlatformMoneymoremore":@"p2",
                 @"Action":@"1",
                 @"CardNo":@"6217586101000298952",
                 @"WithholdBeginDate":@"",
                 @"WithholdEndDate":@"",
                 @"SingleWithholdLimit":@"",
                 @"TotalWithholdLimit":@"",
                 @"RandomTimeStamp":@"",
                 @"Remark1":@"Remark1",
                 @"Remark2":@"Remark2",
                 @"Remark3":@"Remark3",
                 @"NotifyURL":@"http://120.27.46.92/index.php?g=Shuangqian&m=Notify&a=registerbind"} mutableCopy];
    
    
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
