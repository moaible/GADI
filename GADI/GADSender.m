//
//  GADSender.m
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015 MOAI. All rights reserved
//

#import "GADSender.h"

#import <GoogleAnalytics/GAI.h>
#import <GoogleAnalytics/GAIFields.h>
#import <GoogleAnalytics/GAILogger.h>
#import <GoogleAnalytics/GAIDictionaryBuilder.h>

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
    [self updateTracker:tracker atField:field];
    
    NSMutableDictionary *build = [[[GAIDictionaryBuilder createScreenView] set:screenName
                                                                        forKey:kGAIScreenName] build];
    [tracker send:build];
}

- (void)sendEventTrackingWithCategory:(NSString *)category
                               action:(NSString *)action
                                label:(NSString *)label
                                value:(NSNumber *)value
                                field:(GADField *)field
{
    id<GAITracker> tracker = [self trackerWithTrackingID:self.trackingID];
    [self updateTracker:tracker atField:field];
    
    NSMutableDictionary *build = [[GAIDictionaryBuilder createEventWithCategory:category
                                                                         action:action
                                                                          label:label
                                                                          value:value] build];
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
    for (GADCustomDimension *customDimension in field.customDimensions) {
        [tracker set:[GAIFields customDimensionForIndex:customDimension.index] value:customDimension.value];
    }
    
    for (GADCustomMetric *customMetric in field.customMetrics) {
        [tracker set:[GAIFields customMetricForIndex:customMetric.index] value:customMetric.value];
    }
    
    for (GADContentGroup *contentGroup in field.contentGroups) {
        [tracker set:[GAIFields contentGroupForIndex:contentGroup.index] value:contentGroup.value];
    }
    
    if (field.userID) {
        [tracker set:@"&uid" value:field.userID];
    }
}

@end
