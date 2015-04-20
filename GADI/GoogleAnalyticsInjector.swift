//
//  GoogleAnalyticsInjector.swift
//  GAInjector
//
//  Created by 本寺広海 on 2015/04/17.
//  Copyright (c) 2015年 Hiromi Motodera. All rights reserved.
//

import UIKit

private let propertyListFileName = "GoogleAnalyticsConfig.plist"

private let classKey = "Class"

private let methodSignatureKey = "MethodSignature"

private let googleAnalyticsTypeKey = "GA:Type"

enum GoogleAnalyticsType: String {
    case Screen = "Screen"
    case Action = "Action"
}

private let googleAnalyticsScreenKey = "GA:Screen"

private let googleAnalyticsCategoryKey = "GA:Category"

private let googleAnalyticsActionKey = "GA:Action"

private let googleAnalyticsLabelKey = "GA:Label"

public final class GoogleAnalyticsInjector {
    public class func inject() {
        let sender = GoogleAnalyticsSender()
        var configInfos: [[String:String]] = NSArray(contentsOfFile:NSBundle.mainBundle().pathForResource(propertyListFileName, ofType:nil)!) as [[String:String]]
        
        for info in configInfos {
            let className = info[classKey]!
            let methodSignature = info[methodSignatureKey]!
            let googleAnalyticsType = info[googleAnalyticsTypeKey]!
            switch googleAnalyticsType {
            case GoogleAnalyticsType.Screen.rawValue:
                let screenName = info[googleAnalyticsScreenKey]!
                MOAspects.hookInstanceMethodForClass(NSClassFromString(className), selector:Selector(methodSignature), position:.After) {
                    sender.sendScreenTracking(screenName:screenName)
                }
            case GoogleAnalyticsType.Action.rawValue:
                let categoryName = info[googleAnalyticsCategoryKey]!
                let actionName = info[googleAnalyticsActionKey]!
                let labelName = info[googleAnalyticsLabelKey]!
                MOAspects.hookInstanceMethodForClass(NSClassFromString(className), selector:Selector(methodSignature), position:.After) {
                    sender.sendEventTracking(category:categoryName, action:actionName, label:labelName)
                }
            default:
                println("Unknown google analytics type \(googleAnalyticsType). Please setting Screen or Action")
            }
        }
    }
}
