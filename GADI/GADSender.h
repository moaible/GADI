//
//  GADSender.h
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GADField.h"

@interface GADSender : NSObject

@property (nonatomic) NSString *trackingID;

+ (instancetype)sharedSender;

- (void)sendScreenTrackingWithScreenName:(NSString *)screenName
                                   field:(GADField *)field;

- (void)sendEventTrackingWithCategory:(NSString *)category
                               action:(NSString *)action
                                label:(NSString *)label
                                field:(GADField *)field;

@end
