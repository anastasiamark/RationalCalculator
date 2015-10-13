//
//  AMCalculatorController.m
//  RationalCalculator
//
//  Created by Mark on 29.09.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMCalculatorController.h"

#import "AMCalculatorCell.h"

#import "AMArithmeticOperation.h"
#import "AMRationalFraction.h"
#import "AMFractionsCalculator.h"
#import "AMCalculatorItem.h"

#import "AMRationalFraction+NSString.h"
#import "NSString+AMFractionValue.h"

static NSString *const kNumbersCharacters = @"123456789";
static NSString *const kSymbolsCharacters = @"+-*:";
static NSString *const kEqualCharacter = @"=";
static NSString *const kDividingCharacter = @"/";
static NSString *const kZeroCharacter = @"0";

@interface AMCalculatorController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *expressionLabel;

@property (nonatomic) NSArray *calculatorItemsList;
@property (nonatomic) AMFractionsCalculator *calculator;

@end

@implementation AMCalculatorController

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.calculatorItemsList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AMCalculatorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AMCalculatorCell class]) forIndexPath:indexPath];
    
    AMCalculatorItem *currentItem = self.calculatorItemsList[indexPath.item];
    [cell configureWithCalculatorItem:currentItem];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    AMCalculatorItem *currentItem = self.calculatorItemsList[indexPath.item];
    
    switch (currentItem.type) {
        case AMCalculatorItemTypeChangeSign: {
            [self changeSign];
            break;
        }
        case AMCalculatorItemTypeCleanAll: {
            [self cleanExpressionLabel];
            break;
        }
        case AMCalculatorItemTypeCleanOneSymbol: {
            [self cleanOneSymbol];
            break;
        }
        case AMCalculatorItemTypeSymbolOrNumber: {
            [self updateLabelWithItem:currentItem];
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(collectionView.frame) - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumInteritemSpacing;
    
    CGFloat cellWidth = width/4.f;
    CGFloat cellHeiht = cellWidth;
    
    return CGSizeMake(cellHeiht, cellWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2.f;
}

#pragma mark - Filling Calculator Items List

- (NSArray *)calculatorItemsArray
{
    AMCalculatorItem *item1 = [AMCalculatorItem itemWithTitle:@"7" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item2 = [AMCalculatorItem itemWithTitle:@"8" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item3 = [AMCalculatorItem itemWithTitle:@"9" andType:AMCalculatorItemTypeSymbolOrNumber];
    
    AMCalculatorItem *item4 = [AMCalculatorItem itemWithTitle:@":" andType:AMCalculatorItemTypeSymbolOrNumber];
    item4.operationType = AMArithmeticOperationDivision;
    
    AMCalculatorItem *item5 = [AMCalculatorItem itemWithTitle:@"4" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item6 = [AMCalculatorItem itemWithTitle:@"5" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item7 = [AMCalculatorItem itemWithTitle:@"6" andType:AMCalculatorItemTypeSymbolOrNumber];
    
    AMCalculatorItem *item8 = [AMCalculatorItem itemWithTitle:@"*" andType:AMCalculatorItemTypeSymbolOrNumber];
    item8.operationType = AMArithmeticOperationMultiplication;
    
    AMCalculatorItem *item9 = [AMCalculatorItem itemWithTitle:@"1" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item10 = [AMCalculatorItem itemWithTitle:@"2" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item11 = [AMCalculatorItem itemWithTitle:@"3" andType:AMCalculatorItemTypeSymbolOrNumber];
    
    AMCalculatorItem *item12 = [AMCalculatorItem itemWithTitle:@"-" andType:AMCalculatorItemTypeSymbolOrNumber];
    item12.operationType = AMArithmeticOperationSubtraction;
    
    AMCalculatorItem *item13 = [AMCalculatorItem itemWithTitle:@"0" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item14 = [AMCalculatorItem itemWithTitle:@"/" andType:AMCalculatorItemTypeSymbolOrNumber];
    AMCalculatorItem *item15 = [AMCalculatorItem itemWithTitle:@"=" andType:AMCalculatorItemTypeSymbolOrNumber];
    
    AMCalculatorItem *item16 = [AMCalculatorItem itemWithTitle:@"+" andType:AMCalculatorItemTypeSymbolOrNumber];
    item16.operationType = AMArithmeticOperationAddition;
    
    AMCalculatorItem *item17 = [AMCalculatorItem itemWithTitle:@"Clean" andType:AMCalculatorItemTypeCleanAll];
    AMCalculatorItem *item18 = [AMCalculatorItem itemWithTitle:@"<<" andType:AMCalculatorItemTypeCleanOneSymbol];
    AMCalculatorItem *item19 = [AMCalculatorItem itemWithTitle:@"+/-" andType:AMCalculatorItemTypeChangeSign];
    
    return @[item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18, item19];
}

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _calculator = [[AMFractionsCalculator alloc] init];
    }
    return self;
}

#pragma  mark - Accessors

- (NSArray *)calculatorItemsList
{
    if (!_calculatorItemsList) {
        _calculatorItemsList = [self calculatorItemsArray];
    }
    return _calculatorItemsList;
}

#pragma mark - Actions

- (void)cleanOneSymbol
{
    if (![self isExpressionEmpty]) {
        NSString *expression = [self.expressionLabel.text substringToIndex:[self.expressionLabel.text length]-1];
        if ([self isSymbol:[self lastSymbolInExpression]]) {
            [self removeLastOperation];
        }
        self.expressionLabel.text = [NSString stringWithString:expression];
    }
}

- (void)cleanExpressionLabel
{
    self.expressionLabel.text = @"";
    [self.calculator.operations removeAllObjects];
}

- (void)changeSign
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

- (void)updateLabelWithItem:(AMCalculatorItem *)item
{
    NSString *title = item.title;
    
    if (![self isEqualSymbol:title]) {
        [self updateExprssionWithCalculatorItem:item];
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

- (void)addOperationsWithCalculatorItem:(AMCalculatorItem *)item
{
    NSString *title = item.title;
    if ([self isSymbol:title]) {
        AMArithmeticOperation *operation = [AMArithmeticOperation operationWithType:item.operationType];
        [self.calculator.operations addObject:operation];
    }
}

#pragma mark - Control Correct Input

- (void)updateExprssionWithCalculatorItem:(AMCalculatorItem *)item
{
    NSString *title = item.title;
    
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
            [self addOperationsWithCalculatorItem:item];
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