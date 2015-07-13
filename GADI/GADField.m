//
//  GADField.m
//  GADIDemo
//
//  Created by HiromiMotodera on 7/9/15.
//  Copyright (c) 2015 HiromiMotodera. All rights reserved.
//

#import "GADField.h"

@interface GADField ()

@property (nonatomic) NSMutableArray *mutableCustomDimensions;

@property (nonatomic) NSMutableArray *mutableCustomMetrics;

@property (nonatomic) NSMutableArray *mutableContentGroups;

@end

@implementation GADField

#pragma mark - Property

#pragma mark Public

- (NSArray *)customDimensions
{
    return [self.mutableCustomDimensions copy];
}

- (NSArray *)customMetrics
{
    return [self.mutableCustomMetrics copy];
}

- (NSArray *)contentGroups
{
    return [self.mutableContentGroups copy];
}

#pragma mark Private

- (NSMutableArray *)mutableCustomDimensions
{
    if (!_mutableCustomDimensions) {
        _mutableCustomDimensions = [@[] mutableCopy];
    }
    return _mutableCustomDimensions;
}

- (NSMutableArray *)mutableCustomMetrics
{
    if (!_mutableCustomMetrics) {
        _mutableCustomMetrics = [@[] mutableCopy];
    }
    return _mutableCustomMetrics;
}

- (NSMutableArray *)mutableContentGroups
{
    if (!_mutableContentGroups) {
        _mutableContentGroups = [@[] mutableCopy];
    }
    return _mutableContentGroups;
}

#pragma mark - Public

- (void)addCustomDimension:(GADCustomDimension *)customDimension
{
    [self.mutableCustomDimensions addObject:customDimension];
}

- (void)addCustomMetric:(GADCustomMetric *)customMetric
{
    [self.mutableCustomMetrics addObject:customMetric];
}

- (void)addContentGroup:(GADContentGroup *)contentGroup
{
    [self.mutableContentGroups addObject:contentGroup];
}

@end
