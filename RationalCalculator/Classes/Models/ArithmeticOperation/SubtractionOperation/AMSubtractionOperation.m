//
//  AMSubtractionOperation.m
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMSubtractionOperation.h"

@implementation AMSubtractionOperation

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _symbol = @"-";
        _type = AMArithmeticOperationSubtraction;
        _priority = AMArithmeticOperationPriorityLow;
    }
    return self;
}

@end
