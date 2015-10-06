//
//  AMArithmeticOperation.m
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMArithmeticOperation.h"

#import "AMAdditionOperation.h"
#import "AMSubtractionOperation.h"
#import "AMMultiplicationOperation.h"
#import "AMDivisionOperation.h"

@implementation AMArithmeticOperation

#pragma mark - Lifecycle

- (instancetype)initWithOperationType:(AMArithmeticOperationType)operationType
{
    self = [super init];
    if (self) {
        switch (operationType) {
            case AMArithmeticOperationAddition:
                return [[AMAdditionOperation alloc] init];
            case AMArithmeticOperationSubtraction:
                return [[AMSubtractionOperation alloc] init];
            case AMArithmeticOperationMultiplication:
                return [[AMMultiplicationOperation alloc] init];
            case AMArithmeticOperationDivision:
                return [[AMDivisionOperation alloc] init];
        }
    }
    return self;
}

+ (instancetype)operationWithType:(AMArithmeticOperationType)operationType
{
    return [[self alloc] initWithOperationType:operationType];
}

@end
