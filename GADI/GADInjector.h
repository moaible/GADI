//
//  GADInjector.h
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GADLogLevel) {
    GADLogLevelNone = 0,
    GADLogLevelError = 1,
    GADLogLevelWarning = 2,
    GADLogLevelInfo = 3,
    GADLogLevelVerbose = 4
};

@interface GADInjector : NSObject

+ (void)injectWithTrackingID:(NSString *)trackingID configPropertyListPath:(NSString *)path;

+ (void)setLogLevel:(GADLogLevel)level;

@end
