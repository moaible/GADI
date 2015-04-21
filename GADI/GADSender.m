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

@property (nonatomic) id<GAITracker> tracker;

@end

@implementation GADSender

#pragma mark - Initialize

- (instancetype)initWithTrackingID:(NSString *)trackingID
{
    self = [super init];
    if (self) {
        [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
        [[GAI sharedInstance] setDispatchInterval:20];
        [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
        _tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingID];
    }
    return self;
}

#pragma mark - Public

- (void)sendScreenTrackingWithScreenName:(NSString *)screenName
{
    NSMutableDictionary *build = [[[GAIDictionaryBuilder createAppView] set:screenName forKey:kGAIScreenName] build];
    [self.tracker send:build];
}

- (void)sendEventTrackingWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label
{
    NSMutableDictionary *build = [[GAIDictionaryBuilder createEventWithCategory:category
                                                                         action:action
                                                                          label:label
                                                                          value:nil] build];
    [self.tracker send:build];
}

@end
