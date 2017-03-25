//
//  MMMRequestUtil.m
//  MoreSDK
//
//  Created by sunshinek31 on 15/4/14.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMRequestUtil.h"
#import "MMMConfigUtil.h"

static NSStringEncoding stringEncoding = NSUTF8StringEncoding;
@implementation MMMRequestUtil


+(void)sendRequest:(NSString *)URLString
      withPostData:(NSData *)data
     callbackBlock:(void (^)(NSData *, NSError *))callbackBlock {
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:25];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        callbackBlock(data,connectionError);
        
    }];
}

+(void)sendRequest:(NSString *)URLString
      withPostDic:(NSDictionary *)dic
     callbackBlock:(void (^)(NSData *, NSError *))callbackBlock
{
    
    NSURL *url = [NSURL URLWithString:[URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableData *mData = [NSMutableData data];
    NSMutableArray *mDataArr = [NSMutableArray array];
    for (NSString *key in dic) {
        NSString *value = dic[key];
        NSMutableDictionary *keyValuePair = [NSMutableDictionary dictionaryWithCapacity:2];
        [keyValuePair setValue:key forKey:@"key"];
        [keyValuePair setValue:[value description] forKey:@"value"];
        [mDataArr addObject:keyValuePair];
        
        NSData *data = [[NSString stringWithFormat:@"%@=%@&",key,value] dataUsingEncoding:NSUTF8StringEncoding];
        [mData appendData:data];
    }
    
    [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSMutableData *mPostBody = [[NSMutableData alloc]init];
    NSUInteger i =0;
    NSUInteger count = [mDataArr count]-1;
    for (NSDictionary *val in mDataArr) {
        NSString *data = [NSString stringWithFormat:@"%@=%@%@", [self encodeURL:[val objectForKey:@"key"]], [self encodeURL:[val objectForKey:@"value"]],(i<count ?  @"&" : @"")];
        
        [mPostBody appendData:[data dataUsingEncoding:NSUTF8StringEncoding]];
        i++;
    }
    [request addValue:[NSString stringWithFormat:@"%llu",(long long)[mPostBody length]] forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:mPostBody];
    [request setTimeoutInterval:25];
    [request setHTTPMethod:@"POST"];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        callbackBlock(data,connectionError);
        
    }];
}

+ (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(stringEncoding)));
    if (newString) {
        return newString;
        
    }
    return @"";
}


@end
