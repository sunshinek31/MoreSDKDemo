//
//  MMMUrlUtil.h
//  MoreSDK
//
//  Created by sunshinek31 on 15/7/23.
//  Copyright (c) 2015年 moneymoremore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMEventEnum.h"

typedef struct url_util{
    void (*setMainDomain)(MMMEventType event,NSString *newMainDomain);
    NSString *(*getMainDomain)(MMMEventType event);
    NSString *(*getServiceURL)(MMMEventType event);
    NSString *(*getProvinceInfoURL)();
    NSString *(*getCityInfoURL)();
}MMMUrlUtil_t;

#define _MMMUrlUtil ([MMMUrlUtil share])

@interface MMMUrlUtil : NSObject
+(MMMUrlUtil_t)share;
@end
