//
//  GADInjector.h
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015 MOAI. All rights reserved
//

#import <Foundation/Foundation.h>

#import "GADField.h"

#pragma mark - Config Keys
 
FOUNDATION_EXPORT NSString * const GADClassKey;

FOUNDATION_EXPORT NSString * const GADMethodSignatureKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsTypeKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsScreenKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsCategoryKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsActionKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsLabelKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsCustomMetricIndexKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsCustomMetricValueKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsCustomDimensionIndexKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsCustomDimensionValueKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsContentGroupIndexKey;

FOUNDATION_EXPORT NSString * const GADGoogleAnalyticsContentGroupValueKey;

typedef NS_ENUM(NSInteger, GADLogLevel) {
    GADLogLevelNone = 0,
    GADLogLevelError = 1,
    GADLogLevelWarning = 2,
    GADLogLevelInfo = 3,
    GADLogLevelVerbose = 4
};

@interface GADInjector : NSObject

+ (void)injectWithTrackingID:(NSString *)trackingID
      configPropertyListPath:(NSString *)path;

+ (void)injectWithTrackingID:(NSString *)trackingID
      configPropertyListPath:(NSString *)path
                       block:(BOOL (^)(NSDictionary *, GADField *))block;

+ (void)setLogLevel:(GADLogLevel)level;

@end
