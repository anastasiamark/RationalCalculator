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

@end

@implementation AMFractionsCalculator

#pragma mark - lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _operations = [NSMutableArray array];
        _expression = [NSString string];
    }
    return self;
}

#pragma mark - Actions

- (void)performArithmeticalOperationWithExpression:(NSString *)expression
                      withCompletion:(void(^)(AMRationalFraction *resultFraction))completion
{
    AMRationalFraction *resultFraction = [[AMRationalFraction alloc] init];

    if (self.operations.count >= 2) {
        //calculation of operation with high priority
        for (int i = 0; i < self.operations.count; i++)  {
            AMArithmeticOperation *operation = self.operations[i];
            if (operation.priority == AMArithmeticOperationPriorityHigh) {
                NSArray *operands = [self findOperandsForOperationInArray:self.operations atIndex:i withExpressin:expression];
                resultFraction = [self findResultFractionWithOperation:operation andOperands:operands withExpression:expression];
                expression = self.expression;
                [self.operations removeObject:operation];
            }
        }
    }
    
    if (self.operations.count >= 2) {
        //calculation of operation with low priority
        for (int i = 0; i < self.operations.count; i++)  {
            AMArithmeticOperation *operation = self.operations[i];
            NSArray *operands = [self findOperandsForOperationInArray:self.operations atIndex:i withExpressin:expression];
            resultFraction = [self findResultFractionWithOperation:operation andOperands:operands withExpression:expression];
            expression = self.expression;
            [self.operations removeObject:operation];
        }
    }
    
    if (self.operations.count < 2) {
        for (AMArithmeticOperation *operation in self.operations) {
            NSArray *operands = [expression componentsSeparatedByString:operation.symbol];
            if (operands.count == 2) {
                AMRationalFraction *fraction1 = [operands[0] fractionValue];
                AMRationalFraction *fraction2 = [operands[1] fractionValue];
                if (fraction1 && fraction2) {
                    resultFraction = [self performArithmeticalOperationWithType:operation.type forFractionFirst:fraction1 andFractionSecond:fraction2];
                    
                    if (completion) {
                        completion(resultFraction);
                    }
                }
            }
        }
    }
}

- (AMRationalFraction *)findResultFractionWithOperation:(AMArithmeticOperation *)operation andOperands:(NSArray *)operands withExpression:(NSString *)expression
{
    AMRationalFraction *fraction1 = nil;
    AMRationalFraction *fraction2 = nil;
    
    if (operands.count == 2) {
        fraction1 = operands[0];
        fraction2 = operands[1];
    }
    
    AMRationalFraction *resultFraction = [self performArithmeticalOperationWithType:operation.type forFractionFirst:fraction1 andFractionSecond:fraction2];
    
    NSString *resultFractionStringValue = [fraction1 stringFromRationalFractionWithOperationSymbol:operation.symbol andAnotherFraction:fraction2];
    
    NSRange newRange = [expression rangeOfString:resultFractionStringValue];
    
    if (newRange.location != NSNotFound) {
        self.expression = [expression stringByReplacingCharactersInRange:newRange withString:[resultFraction stringFromRationalFraction]];
    }
    return resultFraction;
}

#pragma mark - Private Methods

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

- (NSArray *)findOperandsForOperationInArray:(NSMutableArray *)operations atIndex:(NSInteger)index withExpressin:(NSString *)expression
{
    AMArithmeticOperation *operation = operations[index];
    
    AMRationalFraction *fraction1 = nil;
    AMRationalFraction *fraction2 = nil;

    NSArray *operands = [expression componentsSeparatedByString:operation.symbol];
    if (operands.count >= 2) {
        if (index == 0) {
            fraction1 = [operands[0] fractionValue];
            AMArithmeticOperation *nextOperation = operations[index + 1];
            fraction2 = [operands[1] fractionValueAfterOperation:nextOperation];
            
        } else if (index == (operations.count - 1)) {
            AMArithmeticOperation *previousOperation = operations[index - 1];
            fraction1 = [operands[0] fractionValueBeforeOperation:previousOperation];
            fraction2 = [operands[1] fractionValue];
        } else {
            AMArithmeticOperation *nextOperation = operations[index + 1];
            AMArithmeticOperation *previousOperation = operations[index - 1];
            fraction1 = [operands[0] fractionValueBeforeOperation:previousOperation];
            fraction2 = [operands[1] fractionValueAfterOperation:nextOperation];
        }
    }
    
    return @[fraction1, fraction2];
}

#pragma mark - Arithmetical Operations

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
