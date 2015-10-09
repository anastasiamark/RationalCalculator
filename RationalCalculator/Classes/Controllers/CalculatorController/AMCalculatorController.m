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
#import "AMRationalFraction.h"
#import "AMFractionsCalculator.h"

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
        NSString *expression = [self.expressionLabel.text substringToIndex:[self.expressionLabel.text length]-1];
        if ([self isSymbol:[self lastSymbolInExpression]]) {
            [self removeLastOperation];
        }
        self.expressionLabel.text = [NSString stringWithString:expression];
    }
}

- (IBAction)cleanLabelAction:(AMCalculatorButton *)button
{
    self.expressionLabel.text = @"";
    [self.calculator.operations removeAllObjects];
}

- (IBAction)changeSignAction:(AMCalculatorButton *)button
{
    if (![self isOperationsEmpty] || [self isExpressionEmpty]) {
        return;
    }
    if ([self.expressionLabel.text hasPrefix:@"-"]) {
        self.expressionLabel.text = [self.expressionLabel.text substringFromIndex:1];
    } else {
        NSString *expression = @"-";
        self.expressionLabel.text = [expression stringByAppendingString:self.expressionLabel.text];
    }
}

#pragma mark - Update Label

- (void)updateLabelWithButton:(AMCalculatorButton *)button
{
    NSString *title = button.titleLabel.text;
    
    if (![self isEqualSymbol:title]) {
        [self updateExprssionWithButton:button];
    } else if (![self isExpressionLabelZero]){
        [self updateLabelAfterCalculation];
    }
}

- (void)updateLabelAfterCalculation
{
    if (![self isOperationsEmpty]) {
        __weak typeof(self)weakSelf = self;
        [self.calculator performArithmeticalOperationWithExpression:self.expressionLabel.text withCompletion:^(AMRationalFraction *resultFraction) {
            
            NSString *resultLabel = [resultFraction stringFromRationalFraction];
            weakSelf.expressionLabel.text = [NSString stringWithString:resultLabel];
            [weakSelf.calculator.operations removeAllObjects];
        }];
    } else {
        AMRationalFraction *fraction = [self.expressionLabel.text fractionValue];
        [fraction reduceFraction];
        self.expressionLabel.text = [NSString stringWithString:[fraction stringFromRationalFraction]];
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
        if ([self isZero:self.expressionLabel.text]) {
            self.expressionLabel.text = @"";
        }
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
        if ([self isDividingSymbol:title] && [self isCorrectPositionForSymbol] && [self isNoExcessDividingSymbol]) {
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
    return [self isCorrectPositionForSymbol] && ![self isExpressionLabelZero];
}

- (BOOL)isExpressionLabelZero
{
    return [self.expressionLabel.text isEqualToString:@"0"];
}

- (BOOL)isCorrectPositionForSymbol
{
    return ([self isNumber:[self lastSymbolInExpression]]) || ([self isZero:[self lastSymbolInExpression]]);
}

- (BOOL)isCorrectPositionForFirstCharacter:(NSString *)title
{
    return (![self isZero:title] && ![self isSymbol:title] && ![self isDividingSymbol:title]);
}

- (BOOL)isNoExcessDividingSymbol
{
    if ([self isOperationsEmpty]) {
        NSCharacterSet *expressionSet = [NSCharacterSet characterSetWithCharactersInString:self.expressionLabel.text];
        NSRange dividingSymbolRange = [kDividingCharacter rangeOfCharacterFromSet:expressionSet];
        return dividingSymbolRange.location == NSNotFound;
    }
    AMArithmeticOperation *lastOperation = [self.calculator.operations objectAtIndex:self.calculator.operations.count -1];
    NSString *lastSymbol = lastOperation.symbol;
    NSRange lastSymbolRange = [self.expressionLabel.text rangeOfString:lastSymbol options:NSBackwardsSearch];
    NSString *string = [self.expressionLabel.text substringFromIndex:lastSymbolRange.location];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    NSRange dividingSymbolRange = [kDividingCharacter rangeOfCharacterFromSet:stringSet];
    return dividingSymbolRange.location == NSNotFound;
}

#pragma  mark - Helper Methods

- (void)removeLastOperation
{
    if (![self isOperationsEmpty]) {
        [self.calculator.operations removeObjectAtIndex:self.calculator.operations.count - 1 ];
    }
}

- (void)addSymbolToExpression:(NSString *)symbol
{
    self.expressionLabel.text = [self.expressionLabel.text stringByAppendingString:symbol];
}

- (NSString *)lastSymbolInExpression
{
    if ([self isExpressionEmpty]) {
        return nil;
    }
    
    NSRange lastSymbolRange;
    lastSymbolRange.length = 1;
    lastSymbolRange.location = [self.expressionLabel.text length]-1;
    
    return [self.expressionLabel.text substringWithRange:lastSymbolRange];
}

#pragma mark - Boolean Methods

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
    return !self.expressionLabel.text.length;
}

- (BOOL)isOperationsEmpty
{
    return !self.calculator.operations.count;
}

@end