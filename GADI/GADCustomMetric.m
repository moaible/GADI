//
//  GADCustomMetric.m
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/07/13.
//  Copyright (c) 2015 MOAI. All rights reserved
//

#import "GADCustomMetric.h"

@implementation GADCustomMetric

+ (instancetype)customMetricWithIndex:(NSUInteger)index value:(NSString *)value
{
    GADCustomMetric *customMetric = [[GADCustomMetric alloc] init];
    customMetric.index = index;
    customMetric.value = value;
    return customMetric;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<GADCustomMetric index = %ld, value = %@>", self.index, self.value];
}

@end
