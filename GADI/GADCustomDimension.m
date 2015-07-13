//
//  GADCustomDimension.m
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/07/13.
//  Copyright (c) 2015 MOAI. All rights reserved
//

#import "GADCustomDimension.h"

@implementation GADCustomDimension

+ (instancetype)customDimensionWithIndex:(NSUInteger)index value:(NSString *)value
{
    GADCustomDimension *customDimension = [[GADCustomDimension alloc] init];
    customDimension.index = index;
    customDimension.value = value;
    return customDimension;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<GADCustomDimension index = %ld, value = %@>", self.index, self.value];
}

@end
