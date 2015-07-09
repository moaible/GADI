//
//  GADSender.m
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import "GADSender.h"

#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import <GoogleAnalytics-iOS-SDK/GAILogger.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>

@interface GADSender ()

@end

@implementation GADSender

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)sharedSender
{
    static dispatch_once_t onceToken;
    static GADSender *sender;
    dispatch_once(&onceToken, ^{
        sender = [[GADSender alloc] init];
        
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
        [[GAI sharedInstance] setDispatchInterval:20];
    });
    return sender;
}

#pragma mark - Public

- (void)sendScreenTrackingWithScreenName:(NSString *)screenName
                                   field:(GADField *)field
{
    id<GAITracker> tracker = [self trackerWithTrackingID:self.trackingID];
    
    if (field) {
        [self updateTracker:tracker atField:field];
    }
    
    NSMutableDictionary *build = [[[GAIDictionaryBuilder createScreenView] set:screenName
                                                                        forKey:kGAIScreenName] build];
    [tracker send:build];
}

- (void)sendEventTrackingWithCategory:(NSString *)category
                               action:(NSString *)action
                                label:(NSString *)label
                                field:(GADField *)field
{
    id<GAITracker> tracker = [self trackerWithTrackingID:self.trackingID];
    
    if (field) {
        [self updateTracker:tracker atField:field];
    }
    
    NSMutableDictionary *build = [[GAIDictionaryBuilder createEventWithCategory:category
                                                                         action:action
                                                                          label:label
                                                                          value:nil] build];
    [tracker send:build];
}

#pragma mark - Private

- (id<GAITracker>)trackerWithTrackingID:(NSString *)trackingID
{
    NSAssert(_trackingID && _trackingID.length > 0, @"should not be nil tracking ID");
    return [[GAI sharedInstance] trackerWithTrackingId:trackingID];
}

- (void)updateTracker:(id<GAITracker>)tracker atField:(GADField *)field
{
    if (field.customMetricIndex && field.customMetricValue) {
        [tracker set:[GAIFields customMetricForIndex:field.customDimensionIndex.unsignedIntegerValue]
               value:field.customMetricValue];
    }
    
    if (field.customDimensionIndex && field.customDimensionValue) {
        [tracker set:[GAIFields customDimensionForIndex:field.customDimensionIndex.unsignedIntegerValue]
               value:field.customDimensionValue];
    }
    
    if (field.groupIndex && field.groupValue) {
        [tracker set:[GAIFields contentGroupForIndex:field.groupIndex.unsignedIntegerValue]
               value:field.groupValue];
    }
}

@end
