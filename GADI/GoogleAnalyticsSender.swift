
//
//  GoogleAnalyticsSender.swift
//  GAInjector
//
//  Created by 本寺広海 on 2015/04/17.
//  Copyright (c) 2015年 Hiromi Motodera. All rights reserved.
//

private let googleAnalyticsTrackingID = ""

public class GoogleAnalyticsSender {
    
    // MARK: Property
    
    private var tracker: GAITracker
    
    // MARK: Initialize
    
    public init(trackingID: String = googleAnalyticsTrackingID) {
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = GAILogLevel.Verbose
        self.tracker = GAI.sharedInstance().trackerWithTrackingId(trackingID)
    }

    // MARK: Send tracking

    public func sendScreenTracking(#screenName: String) {
        let build = GAIDictionaryBuilder.createAppView().set(screenName, forKey: kGAIScreenName).build()
        self.tracker.send(build)
    }
    
    public func sendEventTracking(#category: String, action: String, label: String) {
        let build = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: nil).build()
        tracker.send(build)
    }
}
