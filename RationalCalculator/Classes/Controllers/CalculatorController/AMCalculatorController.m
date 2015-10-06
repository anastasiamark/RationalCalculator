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

static NSString *const kNumbersCharacters = @"1234567890";
static NSString *const kSymbolsCharacters = @"+-*:";
static NSString *const kEqualCharacter = @"=";
static NSString *const kDividingCharacter = @"/";

@interface AMCalculatorController ()

@property (weak, nonatomic) IBOutlet UILabel *expression;

@property (nonatomic) AMFractionsCalculator *calculator;
@property (nonatomic) AMRationalFraction *operandFirst;
@property (nonatomic) AMRationalFraction *operandSecond;

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
    NSString *title = button.titleLabel.text;
    
    NSCharacterSet *symbolSet = [NSCharacterSet characterSetWithCharactersInString:kSymbolsCharacters];
    NSRange symbolRange = [title rangeOfCharacterFromSet:symbolSet];
    
    BOOL isSymbol = symbolRange.location != NSNotFound;
    BOOL isEqualSymbol = [title isEqualToString:kEqualCharacter];
    
    if (isSymbol) {
        AMArithmeticOperation *operation = [AMArithmeticOperation operationWithType:(AMArithmeticOperationType)button.tag];
        [self.calculator.operations addObject:operation];
    }
    
    if (!isEqualSymbol) {
        [self updateLabelWithString:title];
    } else {
        [self.calculator performArithmeticalOperationWithExpression:self.expression.text withCompletion:^(AMRationalFraction *resultFraction) {
            
            self.expression.text = [NSString stringWithFormat:@"%ld/%ld", (long)resultFraction.numerator, (long)resultFraction.denominator];
            [self.calculator.operations removeAllObjects];
        }];
    }
}

- (IBAction)cleanLabelAction:(AMCalculatorButton *)button {
    self.expression.text = @"";
}

#pragma mark - Private Methods

- (void)updateLabelWithString:(NSString *)title
{
    self.expression.text = [self.expression.text stringByAppendingString:title];
}

@end
