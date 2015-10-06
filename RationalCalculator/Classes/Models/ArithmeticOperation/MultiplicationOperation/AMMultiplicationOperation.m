//
//  AMMultiplicationOperation.m
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMMultiplicationOperation.h"

@implementation AMMultiplicationOperation

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _symbol = @"*";
        _type = AMArithmeticOperationMultiplication;
        _priority = AMArithmeticOperationPriorityHigh;
    }
    return self;
}

@end
