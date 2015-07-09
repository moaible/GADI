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
{
    id<GAITracker> tracker = [self trackerWithTrackingID:self.trackingID];
    NSMutableDictionary *build = [[[GAIDictionaryBuilder createScreenView] set:screenName
                                                                        forKey:kGAIScreenName] build];
    [tracker send:build];
}

- (void)sendEventTrackingWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label
{
    id<GAITracker> tracker = [self trackerWithTrackingID:self.trackingID];
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

@end
