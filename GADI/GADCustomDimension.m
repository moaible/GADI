//
//  GADCustomDimension.m
//  GADIDemo
//
//  Created by 本寺広海 on 2015/07/13.
//  Copyright (c) 2015年 HiromiMotodera. All rights reserved.
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

@end
