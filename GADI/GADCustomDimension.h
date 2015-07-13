//
//  GADCustomDimension.h
//  GADIDemo
//
//  Created by HiromiMotodera on 2015/07/13.
//  Copyright (c) 2015 MOAI. All rights reserved
//

#import <Foundation/Foundation.h>

@interface GADCustomDimension : NSObject

@property (nonatomic) NSUInteger index;

@property (nonatomic, copy) NSString *value;

+ (instancetype)customDimensionWithIndex:(NSUInteger)index value:(NSString *)value;

@end
