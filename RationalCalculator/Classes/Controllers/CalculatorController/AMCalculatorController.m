//
//  AMCalculatorController.m
//  RationalCalculator
//
//  Created by Mark on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMCalculatorController.h"

#import "AMCalculatorButton.h"
#import "AMArithmeticOperation.h"
#import "AMFractionsCalculator.h"
#import "AMRationalFraction.h"

#import "AMRationalFraction+NSString.h"
#import "NSString+AMFractionValue.h"

static NSString *const kNumbersCharacters = @"123456789";
static NSString *const kSymbolsCharacters = @"+-*:";
static NSString *const kEqualCharacter = @"=";
static NSString *const kDividingCharacter = @"/";
static NSString *const kZeroCharacter = @"0";

@interface AMCalculatorController ()

@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;

@property (nonatomic) AMFractionsCalculator *calculator;

@end

@implementation AMCalculatorController

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _calculator = [[AMFractionsCalculator alloc] init];
    }
    return self;
}

#pragma mark - Actions

- (IBAction)buttonTappedCalculatorAction:(AMCalculatorButton *)button
{
    [self updateLabelWithButton:button];
}
- (IBAction)cleanOneSymbol:(AMCalculatorButton *)button
{
    if (![self isExpressionEmpty]) {
        NSString *newExpression = [self.expression.text substringToIndex:[self.expression.text length]-1];
        if ([self isSymbol:[self lastSymbolInExpression]]) {
            [self removeLastOperation];
        }
        self.expression.text = [NSString stringWithString:newExpression];
    }
}

- (IBAction)cleanLabelAction:(AMCalculatorButton *)button
{
    self.expression.text = @"";
    [self.calculator.operations removeAllObjects];
}



#pragma mark - Update Label

- (void)updateLabelWithButton:(AMCalculatorButton *)button
{
    NSString *title = button.titleLabel.text;
    
    if (![self isEqualSymbol:title]) {
        [self updateExprssionWithButton:button];
    } else {
        [self updateLabelAfterCalculation];
    }
}

- (void)updateLabelAfterCalculation
{
    __block NSString *resultLabelString = [NSString string];
    
    if (![self isOperationsEmpty]) {
        [self.calculator performArithmeticalOperationWithExpression:self.expression.text withCompletion:^(AMRationalFraction *resultFraction) {
            
            resultLabelString = [resultFraction stringFromRationalFraction];
            [self.calculator.operations removeAllObjects];
        }];
        
        self.expression.text = [NSString stringWithString:resultLabelString];
    } else {
        AMRationalFraction *fraction = [self.expression.text fractionValue];
        [fraction reduceFraction];
        self.expression.text = [NSString stringWithString:[fraction stringFromRationalFraction]];
    }
}

#pragma mark - Add Operations

- (void)addOperationsWithButton:(AMCalculatorButton *)button
{
    NSString *title = button.titleLabel.text;
    if ([self isSymbol:title]) {
        AMArithmeticOperation *operation = [AMArithmeticOperation operationWithType:(AMArithmeticOperationType)button.tag];
        [self.calculator.operations addObject:operation];
    }
}

#pragma mark - Control Correct Input 

- (void)updateExprssionWithButton:(AMCalculatorButton *)button
{
    NSString *title = button.titleLabel.text;
    
    if (![self isExpressionEmpty]) {
        if ([self isNumber:title]) {
            [self addSymbolToExpression:title];
            return;
        }
        if ([self isZero:title] && [self isCorrectPositionForZero]) {
            [self addSymbolToExpression:title];
            return;
        }
        if ([self isSymbol:title] && [self isCorrectPositionForSymbol]) {
            [self addSymbolToExpression:title];
            [self addOperationsWithButton:button];
            return;
        }
        if ([self isDividingSymbol:title] && [self isCorrectPositionForSymbol]) {
            [self addSymbolToExpression:title];
            return;
        }
    } else if ([self isCorrectPositionForFirstCharacter:title]) {
        [self addSymbolToExpression:title];
        return;
    }
}

- (BOOL)isCorrectPositionForZero
{
    return [self isNumber:[self lastSymbolInExpression]];
}

- (BOOL)isCorrectPositionForSymbol
{
    return ([self isNumber:[self lastSymbolInExpression]]) || ([self isZero:[self lastSymbolInExpression]]);
}

- (BOOL)isCorrectPositionForFirstCharacter:(NSString *)title
{
    return (![self isZero:title] && ![self isSymbol:title] && ![self isDividingSymbol:title]);
}

#pragma  mark - Helper Methods

- (void)removeLastOperation
{
    if (![self isOperationsEmpty]) {
        [self.calculator.operations removeObjectAtIndex: self.calculator.operations.count - 1 ];
    }
}

- (void)addSymbolToExpression:(NSString *)symbol
{
    self.expression.text = [self.expression.text stringByAppendingString:symbol];
}

- (NSString *)lastSymbolInExpression
{
    if (![self isExpressionEmpty]) {
        NSRange lastSymbol;
        lastSymbol.length = 1;
        lastSymbol.location = [self.expression.text length]-1;
        
        return [self.expression.text substringWithRange:lastSymbol];
    }
    return nil;
}

#pragma mark - Boolian Methods

- (BOOL)isZero:(NSString *)title
{
    return [title isEqualToString:kZeroCharacter];
}

- (BOOL)isNumber:(NSString *)title
{
    NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:kNumbersCharacters];
    NSRange numberRange = [title rangeOfCharacterFromSet:numberSet];
    
    return numberRange.location != NSNotFound;
}
- (BOOL)isSymbol:(NSString *)title
{
    NSCharacterSet *symbolSet = [NSCharacterSet characterSetWithCharactersInString:kSymbolsCharacters];
    NSRange symbolRange = [title rangeOfCharacterFromSet:symbolSet];
    
    return symbolRange.location != NSNotFound;
}

- (BOOL)isEqualSymbol:(NSString *)title
{
    return [title isEqualToString:kEqualCharacter];
}

- (BOOL)isDividingSymbol:(NSString *)title
{
    return [title isEqualToString:kDividingCharacter];
}

- (BOOL)isExpressionEmpty
{
    return self.expression.text.length == 0;
}

- (BOOL)isOperationsEmpty
{
    return self.calculator.operations.count == 0;
}

@end