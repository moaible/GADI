//
//  GADInjector.m
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import "GADInjector.h"

#import "GADSender.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAILogger.h>
#import <MOAspects/MOAspects.h>

#pragma mark - Config Keys

NSString * const GADClassKey = @"Class";

NSString * const GADMethodSignatureKey = @"MethodSignature";

NSString * const GADGoogleAnalyticsTypeKey = @"GA:Type";

NSString * const GADGoogleAnalyticsScreenKey = @"GA:Screen";

NSString * const GADGoogleAnalyticsCategoryKey = @"GA:Category";

NSString * const GADGoogleAnalyticsActionKey = @"GA:Action";

NSString * const GADGoogleAnalyticsLabelKey = @"GA:Label";

NSString * const GADGoogleAnalyticsCustomMetricIndexKey = @"GA:CustomMetricIndex";

NSString * const GADGoogleAnalyticsCustomMetricValueKey = @"GA:CustomMetricValue";

NSString * const GADGoogleAnalyticsCustomDimensionIndexKey = @"GA:CustomDimensionIndex";

NSString * const GADGoogleAnalyticsCustomDimensionValueKey = @"GA:CustomDimensionValue";

NSString * const GADGoogleAnalyticsContentGroupIndexKey = @"GA:GroupIndex";

NSString * const GADGoogleAnalyticsContentGroupValueKey = @"GA:GroupValue";

#pragma mark - Tracking Types

NSString * const GADTrackingTypeScreen = @"Screen";

NSString * const GADTrackingTypeEvent = @"Event";

#pragma mark - Type

typedef NS_ENUM(NSInteger, GADMethodSignatureType) {
    GADMethodSignatureTypeUnknown = 0,
    GADMethodSignatureTypeClass,
    GADMethodSignatureTypeInstance
};

typedef void (^GADInjection)(NSString *trackingID);

#pragma mark -

@interface GADInjector ()

@end

@implementation GADInjector

#pragma mark - Public

+ (void)injectWithTrackingID:(NSString *)trackingID
      configPropertyListPath:(NSString *)path
{
    [self injectWithTrackingID:trackingID configPropertyListPath:path block:nil];
}

+ (void)injectWithTrackingID:(NSString *)trackingID
      configPropertyListPath:(NSString *)path
                       block:(BOOL (^)(NSDictionary *, GADField *))block
{
    // Set google analytics tracking id here
    [[GADSender sharedSender] setTrackingID:trackingID];
    
    NSArray *configs = [[NSArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *config in configs) {
        if (![self isValidConfig:config]) {
            return;
        }
        
        Class clazz = NSClassFromString(config[GADClassKey]);
        NSString *methodSignature = config[GADMethodSignatureKey];
        NSString *headString = [methodSignature substringWithRange:NSMakeRange(0, 1)];
        GADMethodSignatureType methodSignatureType = [self methodSignatureTypeWithString:headString];
        
        NSString *selectorName;
        switch (methodSignatureType) {
            case GADMethodSignatureTypeClass:
            case GADMethodSignatureTypeInstance:
                selectorName = [methodSignature substringFromIndex:1];
                break;
            case GADMethodSignatureTypeUnknown:
                selectorName = methodSignature;
                break;
        }
        SEL selector = NSSelectorFromString(selectorName);
        
        // TODO: クラスがセレクタを保持してるかどうかのチェックでAssertion
        
        __weak typeof(self) weakSelf = self;
        switch (methodSignatureType) {
            case GADMethodSignatureTypeClass: {
                [MOAspects hookClassMethodForClass:clazz
                                          selector:selector
                                   aspectsPosition:MOAspectsPositionAfter
                                        usingBlock:^{
                                            [weakSelf injectionWithType:methodSignatureType
                                                                 config:config
                                                                  block:block](trackingID);
                                        }];
                break;
            }
            case GADMethodSignatureTypeInstance:
            case GADMethodSignatureTypeUnknown: {
                [MOAspects hookInstanceMethodForClass:clazz
                                             selector:selector
                                      aspectsPosition:MOAspectsPositionAfter
                                           usingBlock:^{
                                               [weakSelf injectionWithType:methodSignatureType
                                                                    config:config
                                                                     block:block](trackingID);
                                           }];
                break;
            }
        }
    }
}

+ (void)setLogLevel:(GADLogLevel)level
{
    [[[GAI sharedInstance] logger] setLogLevel:(GAILogLevel)level];
}

#pragma mark - Private

+ (BOOL)isValidConfig:(NSDictionary *)config
{
    if (!config[GADClassKey]) {
        NSAssert(config[GADClassKey], @"Class should not be nil");
        return NO;
    } else if (!config[GADMethodSignatureKey]) {
        NSAssert(config[GADMethodSignatureKey], @"MethodSignature should not be nil");
        return NO;
    } else if (!config[GADGoogleAnalyticsTypeKey]) {
        NSAssert(config[GADGoogleAnalyticsTypeKey], @"GA:Type should not be nil");
        return NO;
    } else if (!NSClassFromString(config[GADClassKey])) {
        NSAssert(NSClassFromString(config[GADClassKey]), @"Not found class %@",
                 config[GADClassKey]);
        return NO;
    }
    
    return YES;
}

+ (GADMethodSignatureType)methodSignatureTypeWithString:(NSString *)string
{
    if ([string isEqualToString:@"+"]) {
        return GADMethodSignatureTypeClass;
    } else if ([string isEqualToString:@"-"]) {
        return GADMethodSignatureTypeInstance;
    }
    return GADMethodSignatureTypeUnknown;
}

+ (GADInjection)injectionWithType:(GADMethodSignatureType)type
                           config:(NSDictionary *)config
{
    return [self injectionWithType:type config:config block:nil];
}

+ (GADInjection)injectionWithType:(GADMethodSignatureType)type
                           config:(NSDictionary *)config
                            block:(BOOL (^) (NSDictionary *, GADField *))block
{
    NSString *googleAnalyticsType = config[GADGoogleAnalyticsTypeKey];
    GADInjection injection;
    if ([googleAnalyticsType isEqualToString:GADTrackingTypeScreen]) {
        injection = ^(NSString *trackingID) {
            GADField *field = [self fieldWithConfig:config];
            if (block) {
                if (!block(config, field)) {
                    return;
                }
            }
            
            [[GADSender sharedSender] sendScreenTrackingWithScreenName:config[GADGoogleAnalyticsScreenKey]
                                                                 field:field];
        };
    } else if ([googleAnalyticsType isEqualToString:GADTrackingTypeEvent]) {
        injection = ^(NSString *trackingID) {
            GADField *field = [self fieldWithConfig:config];
            if (block) {
                if (!block(config, field)) {
                    return;
                }
            }
            
            [[GADSender sharedSender] sendEventTrackingWithCategory:config[GADGoogleAnalyticsCategoryKey]
                                                             action:config[GADGoogleAnalyticsActionKey]
                                                              label:config[GADGoogleAnalyticsLabelKey]
                                                              field:field];
        };
    } else {
        NSAssert(NO, @"GA:Type is Screen or Event");
    }
    return injection;
}

+ (GADField *)fieldWithConfig:(NSDictionary *)config
{
    GADField *field = [[GADField alloc] init];
    
    if (config[GADGoogleAnalyticsCustomDimensionIndexKey] && config[GADGoogleAnalyticsCustomDimensionValueKey]) {
        [field addCustomDimension:
         [GADCustomDimension customDimensionWithIndex:[config[GADGoogleAnalyticsCustomDimensionIndexKey] integerValue]
                                                value:config[GADGoogleAnalyticsCustomDimensionValueKey]]];
    }
    
    if (config[GADGoogleAnalyticsCustomMetricIndexKey] && config[GADGoogleAnalyticsCustomMetricValueKey]) {
        [field addCustomMetric:
         [GADCustomMetric customMetricWithIndex:[config[GADGoogleAnalyticsCustomMetricIndexKey] integerValue]
                                          value:config[GADGoogleAnalyticsCustomMetricValueKey]]];
    }
    
    if (config[GADGoogleAnalyticsContentGroupIndexKey] && config[GADGoogleAnalyticsContentGroupValueKey]) {
        [field addContentGroup:
         [GADContentGroup contentGroupWithIndex:[config[GADGoogleAnalyticsContentGroupIndexKey] integerValue]
                                          value:config[GADGoogleAnalyticsContentGroupValueKey]]];
    }
    
    return field;
}

@end
