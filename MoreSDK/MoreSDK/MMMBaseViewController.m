//
//  MMMBaseViewController.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/1/19.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import "MMMBaseViewController.h"
#import "MMMConfigUtil.h"

@implementation MMMBaseViewController

-(void)setParams:(NSDictionary *)params signIfnoBlock:(NSString *(^)(NSString *signInfo, BOOL isSignWithPrivateKey))signBlock
{
    _signDataDic = [params mutableCopy];
    _signInfoBlock = signBlock;
}

-(void)setParams:(NSDictionary *)params
   signIfnoBlock:(NSString *(^)(NSString *, BOOL))signBlock
     resultBlock:(void (^)(NSDictionary *, MMMEventType))resultBlock
{
    _signDataDic = [params mutableCopy];
    _signInfoBlock = signBlock;
    _resultBlock = resultBlock;
}


-(id)init {
    self = [super init];
    if (self) {
        
        self.view.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:221.0f/255.0f blue:227.0f/255.0f alpha:1];
        
        _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44+20)];
        UIView *theBackView = [[UIView alloc]initWithFrame:self.toolbar.bounds];
        theBackView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        theBackView.backgroundColor = [UIColor colorWithRed:31.0f/255.0f green:68.0f/255.0f blue:160.0f/255.0f alpha:1];
        [_toolbar addSubview:theBackView];
        [self.view addSubview:_toolbar];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 21)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.center = CGPointMake(_toolbar.center.x, _toolbar.frame.size.height/2+10);
        //        _titleLabel.text = @"test";
        [self.view addSubview:_titleLabel];
        
        UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
        [_toolbar setItems:@[leftBtnItem]];
        
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+20, self.view.bounds.size.width, self.view.bounds.size.height-44-20)];
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _contentView.clipsToBounds = YES;
        [self.view addSubview:_contentView];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super init];
    if (self) {
        self.view = [[UIView alloc]initWithFrame:frame];
        self.view.backgroundColor = [UIColor colorWithRed:216.0f/255.0f green:221.0f/255.0f blue:227.0f/255.0f alpha:1];
        
        _toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44+20)];
        UIView *theBackView = [[UIView alloc]initWithFrame:self.toolbar.bounds];
        theBackView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        theBackView.backgroundColor = [UIColor colorWithRed:31.0f/255.0f green:68.0f/255.0f blue:160.0f/255.0f alpha:1];
        [_toolbar addSubview:theBackView];
        [self.view addSubview:_toolbar];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 21)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.center = CGPointMake(_toolbar.center.x, _toolbar.frame.size.height/2+10);
        //        _titleLabel.text = @"test";
        [self.view addSubview:_titleLabel];
        
        UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
        [_toolbar setItems:@[leftBtnItem]];
        
        
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 44+20, self.view.bounds.size.width, self.view.bounds.size.height-44-20)];
        _contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _contentView.clipsToBounds = YES;
        [self.view addSubview:_contentView];
    }
    return self;
}

-(void)setVCDelegate:(id)VCDelegate {
    self.viewControllDelegate = VCDelegate;
}

-(void)back:(id)sender {
    [MMMActivityIndicatorView remove];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MMMBaseViewControllerRemove" object:nil];
    
    if ([self.view window]) {
        self.theAlert.delegate = nil;
        
        [self dismissViewControllerAnimated:YES completion:^{
            //        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------------------
-(BOOL)checkNecessaryParams:(const char *)className tagertObj:(id)obj {
    id ObjectClass = objc_getClass(className);
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(ObjectClass, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propName = [NSString stringWithUTF8String:property_getName(property)];
        id value = [obj valueForKey:propName];
        if (value == nil){
            return NO;
        }
    }
    
    return YES;
}

-(void)errorOfCallBack:(NSError *)error {
    self.theAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:[error localizedDescription] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [self.theAlert show];
}

-(void)callBackOfRequest:(NSData *)data withTag:(NSUInteger)tag {
    // TODO
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
@end
