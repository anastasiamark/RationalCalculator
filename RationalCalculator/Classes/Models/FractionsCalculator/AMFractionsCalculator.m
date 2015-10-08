//
//  AMFractionsCalculator.m
//  RationalCalculator
//
//  Created by Mark on 03.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMFractionsCalculator.h"

#import "AMArithmeticOperation.h"
#import "AMRationalFraction.h"

#import "NSString+AMFractionValue.h"
#import "AMRationalFraction+NSString.h"

@interface AMFractionsCalculator ()

@property (nonatomic) NSString *expression;
@property (copy, nonatomic) FractionResult result;

@end

@implementation AMFractionsCalculator

#pragma mark - lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operations = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Actions

- (void)performArithmeticalOperationWithExpression:(NSString *)expression
                      withCompletion:(FractionResult)completion
{
    self.expression = expression;
    self.result = completion;
    
    if (self.operations.count >= 2) {
        [self performOperations];
    }
    if (self.operations.count < 2) {
        [self performOperation];
    }
}

#pragma mark - Perform Operations 

- (void)performOperations
{
    NSArray *sortedOperations = [self.operations sortedArrayUsingComparator:^NSComparisonResult(AMArithmeticOperation   * _Nonnull operation1, AMArithmeticOperation  *_Nonnull operation2) {
        return operation1.priority < operation2.priority;
    }];
    
    for (int i = 0; i < sortedOperations.count; i++) {
        AMArithmeticOperation *sortedOperation = sortedOperations[i];
        for (int j = 0; j < self.operations.count; j++)  {
            AMArithmeticOperation *operation = self.operations[j];
            if ([sortedOperation.symbol isEqualToString:operation.symbol]) {
                NSArray *operands = [self findOperandsWithOperationIndex:j];
                [self findResultExpressionAfterOperation:operation withOperands:operands];
                [self.operations removeObject:operation];
                if (self.operations.count == 1) {
                    return;
                }
            }
        }
    }
}

- (void)performOperation
{
    for (AMArithmeticOperation *operation in self.operations) {
        NSArray *operands = [self.expression componentsSeparatedByString:operation.symbol];
        if (operands.count == 2) {
            AMRationalFraction *fraction1 = [operands[0] fractionValue];
            AMRationalFraction *fraction2 = [operands[1] fractionValue];
            if (fraction1 && fraction2) {
                AMRationalFraction *resultFraction = [self performArithmeticalOperationWithType:operation.type forFractionFirst:fraction1 andFractionSecond:fraction2];
                [resultFraction reduceFraction];
                if (self.result) {
                    self.result(resultFraction);
                }
            }
        }
    }
}

#pragma mark - Modify Expretion

- (void)findResultExpressionAfterOperation:(AMArithmeticOperation *)operation withOperands:(NSArray *)operands
{
    AMRationalFraction *fraction1 = nil;
    AMRationalFraction *fraction2 = nil;
    
    if (operands.count == 2) {
        fraction1 = operands[0];
        fraction2 = operands[1];
    }
    
    AMRationalFraction *resultFraction = [self performArithmeticalOperationWithType:operation.type forFractionFirst:fraction1 andFractionSecond:fraction2];
    
    NSString *resultFractionStringValue = [fraction1 stringFromRationalFractionWithOperationSymbol:operation.symbol andAnotherFraction:fraction2];
    
    NSRange newRange = [self.expression rangeOfString:resultFractionStringValue];
    
    if (newRange.location != NSNotFound) {
        self.expression = [self.expression stringByReplacingCharactersInRange:newRange withString:[resultFraction stringFromRationalFraction]];
    }
}

#pragma mark -  Finding Operands For Operation

- (NSArray *)findOperandsWithOperationIndex:(NSInteger)index
{
    AMArithmeticOperation *operation = self.operations[index];
    
    AMRationalFraction *fraction1 = nil;
    AMRationalFraction *fraction2 = nil;

    NSArray *operands = [self.expression componentsSeparatedByString:operation.symbol];
    if (operands.count >= 2) {
        if (index == 0) {
            fraction1 = [operands[0] fractionValue];
            AMArithmeticOperation *nextOperation = self.operations[index + 1];
            fraction2 = [operands[1] fractionValueAfterOperation:nextOperation];
            
        } else if (index == (self.operations.count - 1)) {
            AMArithmeticOperation *previousOperation = self.operations[index - 1];
            fraction1 = [operands[0] fractionValueBeforeOperation:previousOperation];
            fraction2 = [operands[1] fractionValue];
        } else {
            AMArithmeticOperation *nextOperation = self.operations[index + 1];
            AMArithmeticOperation *previousOperation = self.operations[index - 1];
            fraction1 = [operands[0] fractionValueBeforeOperation:previousOperation];
            fraction2 = [operands[1] fractionValueAfterOperation:nextOperation];
        }
    }
    
    return @[fraction1, fraction2];
}

#pragma mark - Arithmetical Operations

- (AMRationalFraction *)performArithmeticalOperationWithType:(AMArithmeticOperationType)operationType forFractionFirst:(AMRationalFraction *)fraction1 andFractionSecond:(AMRationalFraction *)fraction2
{
    AMRationalFraction *resultFraction;
    
    switch (operationType) {
        case AMArithmeticOperationAddition: {
            resultFraction = [[self class] addFraction1:fraction1 andFraction2:fraction2];
            break;
        }
        case AMArithmeticOperationSubtraction: {
            resultFraction = [[self class] subtractFraction1:fraction1 andFraction2:fraction2];
            break;
        }
        case AMArithmeticOperationMultiplication: {
            resultFraction = [[self class] multiplyFraction1:fraction1 andFraction2:fraction2];
            break;
        }
        case AMArithmeticOperationDivision: {
            resultFraction = [[self class] divideFraction1:fraction1 andFraction2:fraction2];
            break;
        }
        default:
            break;
    }
    
    return resultFraction;
}

+ (AMRationalFraction *)addFraction1:(AMRationalFraction *)fraction1 andFraction2:(AMRationalFraction *)fraction2
{
    NSInteger resultDenominator = [fraction1 calculateLCMForNumber1:fraction1.denominator andNumber2:fraction2.denominator];
    NSInteger resultNumerator = (fraction1.numerator * (resultDenominator / fraction1.denominator)) + (fraction2.numerator * (resultDenominator / fraction2.denominator));
    AMRationalFraction *resultFraction = [AMRationalFraction fractionWithIntegerPart:resultNumerator andFractionalPart:resultDenominator];
    
    return resultFraction;
}

+ (AMRationalFraction *)subtractFraction1:(AMRationalFraction *)fraction1 andFraction2:(AMRationalFraction *)fraction2
{
    NSInteger resultDenominator = [fraction1 calculateLCMForNumber1:fraction1.denominator andNumber2:fraction2.denominator];
    NSInteger resultNumerator = (fraction1.numerator * (resultDenominator / fraction1.denominator)) - (fraction2.numerator * (resultDenominator / fraction2.denominator));
    AMRationalFraction *resultFraction = [AMRationalFraction fractionWithIntegerPart:resultNumerator andFractionalPart:resultDenominator];
    
    return resultFraction;
}

+ (AMRationalFraction *)divideFraction1:(AMRationalFraction *)fraction1 andFraction2:(AMRationalFraction *)fraction2
{
    NSInteger resultNumerator = fraction1.numerator * fraction2.denominator;
    NSInteger resultDenominator = fraction1.denominator * fraction2.numerator;
    AMRationalFraction *resultFraction = [AMRationalFraction fractionWithIntegerPart:resultNumerator andFractionalPart:resultDenominator];
    
    return resultFraction;
}

+ (AMRationalFraction *)multiplyFraction1:(AMRationalFraction *)fraction1 andFraction2:(AMRationalFraction *)fraction2
{
    NSInteger resultNumerator = fraction1.numerator * fraction2.numerator;
    NSInteger resultDenominator = fraction1.denominator * fraction2.denominator;
    AMRationalFraction *resultFraction = [AMRationalFraction fractionWithIntegerPart:resultNumerator andFractionalPart:resultDenominator];
    
    return resultFraction;
}

@end