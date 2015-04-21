//
//  GADInjector.h
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/04/21.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GADInjector : NSObject

+ (void)injectWithTrackingID:(NSString *)trackingID configPropertyListPath:(NSString *)path;

@end
