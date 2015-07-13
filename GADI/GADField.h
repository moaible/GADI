//
//  GADField.h
//  GADIDemo
//
//  Created by HiromiMotodera on 7/9/15.
//  Copyright (c) 2015 MOAI. All rights reserved
//

#import <Foundation/Foundation.h>

#import "GADContentGroup.h"
#import "GADCustomDimension.h"
#import "GADCustomMetric.h"

@interface GADField : NSObject

/**
 * Google analytics custom metrics field objects
 * @see GADCustomMetric
 */
@property (nonatomic, copy, readonly) NSArray *customMetrics;

/**
 * Google analytics custom dimension field objects
 * @see GADCustomDimension
 */
@property (nonatomic, copy, readonly) NSArray *customDimensions;

/**
 * Google analytics content group field objects
 * @see GADContentGroup
 */
@property (nonatomic, copy, readonly) NSArray *contentGroups;

- (void)addCustomDimension:(GADCustomDimension *)customDimension;

- (void)addCustomMetric:(GADCustomMetric *)customMetric;

- (void)addContentGroup:(GADContentGroup *)contentGroup;

@end
