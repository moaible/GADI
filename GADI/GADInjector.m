//
//  GADInjector.m
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import "GADInjector.h"

#import "GADSender.h"
#import <MOAspects/MOAspects.h>

#pragma mark - Config Keys

NSString * const GADClassKey = @"Class";

NSString * const GADMethodSignatureKey = @"MethodSignature";

NSString * const GADGoogleAnalyticsTypeKey = @"GA:Type";

NSString * const GADGoogleAnalyticsScreenKey = @"GA:Screen";

NSString * const GADGoogleAnalyticsCategoryKey = @"GA:Category";

NSString * const GADGoogleAnalyticsActionKey = @"GA:Action";

NSString * const GADGoogleAnalyticsLabelKey = @"GA:Label";

#pragma mark - Enum

typedef NS_ENUM(NSInteger, GADMethodSignatureType) {
    GADMethodSignatureTypeUnknown = 0,
    GADMethodSignatureTypeClass,
    GADMethodSignatureTypeInstance
};

#pragma mark -

@interface GADInjector ()

@end

@implementation GADInjector

#pragma mark - Public

+ (void)injectWithTrackingID:(NSString *)trackingID configPropertyListPath:(NSString *)path
{
    NSArray *configs = [[NSArray alloc] initWithContentsOfFile:path];
    for (NSDictionary *config in configs) {
        NSAssert(config[GADClassKey], @"Class should not be nil");
        NSAssert(config[GADMethodSignatureKey], @"MethodSignature should not be nil");
        NSAssert(config[GADGoogleAnalyticsTypeKey], @"GA:Type should not be nil");
        
        Class clazz = NSClassFromString(config[GADClassKey]);
        NSAssert(clazz, @"Not found class %@", config[GADClassKey]);
        
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
        
        NSString *googleAnalyticsType = config[GADGoogleAnalyticsTypeKey];
        void (^injection)(void);
        if ([googleAnalyticsType isEqualToString:@"Screen"]) {
            injection = ^{
                GADSender *sender = [[GADSender alloc] initWithTrackingID:trackingID];
                [sender sendScreenTrackingWithScreenName:config[GADGoogleAnalyticsScreenKey]];
            };
        } else if ([googleAnalyticsType isEqualToString:@"Event"]) {
            injection = ^{
                GADSender *sender = [[GADSender alloc] initWithTrackingID:trackingID];
                [sender sendEventTrackingWithCategory:config[GADGoogleAnalyticsCategoryKey]
                                               action:config[GADGoogleAnalyticsActionKey]
                                                label:config[GADGoogleAnalyticsLabelKey]];
            };
        } else {
            NSAssert(NO, @"GA:Type is Screen or Event");
        }
        
        switch (methodSignatureType) {
            case GADMethodSignatureTypeClass: {
                [MOAspects hookClassMethodForClass:clazz
                                          selector:selector
                                   aspectsPosition:MOAspectsPositionAfter
                                        usingBlock:^{
                                            injection();
                                        }];
                break;
            }
            case GADMethodSignatureTypeInstance:
            case GADMethodSignatureTypeUnknown: {
                [MOAspects hookInstanceMethodForClass:clazz
                                             selector:selector
                                      aspectsPosition:MOAspectsPositionAfter
                                           usingBlock:^{
                                               injection();
                                           }];
                break;
            }
        }
    }
}

#pragma mark - Private

+ (GADMethodSignatureType)methodSignatureTypeWithString:(NSString *)string
{
    if ([string isEqualToString:@"+"]) {
        return GADMethodSignatureTypeClass;
    } else if ([string isEqualToString:@"-"]) {
        return GADMethodSignatureTypeInstance;
    }
    return GADMethodSignatureTypeUnknown;
}

@end
