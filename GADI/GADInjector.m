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

+ (void)injectWithTrackingID:(NSString *)trackingID configPropertyListPath:(NSString *)path
{
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
                                                                 config:config](trackingID);
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
                                                                    config:config](trackingID);
                                           }];
                break;
            }
        }
    }
}

+ (void)setLogLevel:(GADLogLevel)level
{
    [[[GAI sharedInstance] logger] setLogLevel:level];
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
    NSString *googleAnalyticsType = config[GADGoogleAnalyticsTypeKey];
    GADInjection injection;
    if ([googleAnalyticsType isEqualToString:@"Screen"]) {
        injection = ^(NSString *trackingID){
            GADSender *sender = [[GADSender alloc] initWithTrackingID:trackingID];
            [sender sendScreenTrackingWithScreenName:config[GADGoogleAnalyticsScreenKey]];
        };
    } else if ([googleAnalyticsType isEqualToString:@"Event"]) {
        injection = ^(NSString *trackingID){
            GADSender *sender = [[GADSender alloc] initWithTrackingID:trackingID];
            [sender sendEventTrackingWithCategory:config[GADGoogleAnalyticsCategoryKey]
                                           action:config[GADGoogleAnalyticsActionKey]
                                            label:config[GADGoogleAnalyticsLabelKey]];
        };
    } else {
        NSAssert(NO, @"GA:Type is Screen or Event");
    }
    return injection;
}

@end
