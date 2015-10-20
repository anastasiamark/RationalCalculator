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

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSMutableArray *calculatorItemsList;
@property (nonatomic) AMFractionsCalculator *calculator;
@property (nonatomic) AMCalculatorItem *expressionItem;

@end

@implementation AMCalculatorController

#pragma  mark - Accessors

- (NSArray *)calculatorItemsList
{
    if (!_calculatorItemsList) {
        _calculatorItemsList = [self calculatorItemsArray];
    }
    return _calculatorItemsList;
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

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

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
        case AMCalculatorItemTypeSymbol:
        case AMCalculatorItemTypeNumber: {
            [self updateLabelWithItem:currentItem];
            break;
        }
            
        default:
            break;
    }
    [self reloadFirstItem];
}

#pragma mark - UICollectionViewDelegateFlowLayout

static CGFloat const kMinimumSpace = 2.f;
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellWidth;
    CGFloat cellHeiht;
    CGFloat width = CGRectGetWidth(collectionView.frame);
    CGFloat widthWithoutMinInteritemSpacing = width - ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumInteritemSpacing;
    AMCalculatorItem *currentItem = self.calculatorItemsList[indexPath.item];
    if (currentItem.type == AMCalculatorItemTypeExpression) {
        cellHeiht = width/(2 * kMinimumSpace);
        cellWidth = width;
    } else if (currentItem.type == AMCalculatorItemTypeCleanAll) {
        cellHeiht = widthWithoutMinInteritemSpacing/(2 * kMinimumSpace);
        cellWidth = width/kMinimumSpace;
    } else {
        cellWidth = widthWithoutMinInteritemSpacing/(2 * kMinimumSpace);
        cellHeiht = cellWidth;
    }
    
    return CGSizeMake(cellWidth, cellHeiht);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinimumSpace;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinimumSpace;
}

#pragma mark - Filling Calculator Items List

- (NSMutableArray *)calculatorItemsArray
{
    AMCalculatorItem *item0 = [AMCalculatorItem itemWithTitle:@"" andType:AMCalculatorItemTypeExpression];
    self.expressionItem = item0;
    
    AMCalculatorItem *item1 = [AMCalculatorItem itemWithTitle:@"7" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item2 = [AMCalculatorItem itemWithTitle:@"8" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item3 = [AMCalculatorItem itemWithTitle:@"9" andType:AMCalculatorItemTypeNumber];
    
    AMCalculatorItem *item4 = [AMCalculatorItem itemWithTitle:@":" andType:AMCalculatorItemTypeSymbol];
    item4.operationType = AMArithmeticOperationDivision;
    
    AMCalculatorItem *item5 = [AMCalculatorItem itemWithTitle:@"4" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item6 = [AMCalculatorItem itemWithTitle:@"5" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item7 = [AMCalculatorItem itemWithTitle:@"6" andType:AMCalculatorItemTypeNumber];
    
    AMCalculatorItem *item8 = [AMCalculatorItem itemWithTitle:@"*" andType:AMCalculatorItemTypeSymbol];
    item8.operationType = AMArithmeticOperationMultiplication;
    
    AMCalculatorItem *item9 = [AMCalculatorItem itemWithTitle:@"1" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item10 = [AMCalculatorItem itemWithTitle:@"2" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item11 = [AMCalculatorItem itemWithTitle:@"3" andType:AMCalculatorItemTypeNumber];
    
    AMCalculatorItem *item12 = [AMCalculatorItem itemWithTitle:@"-" andType:AMCalculatorItemTypeSymbol];
    item12.operationType = AMArithmeticOperationSubtraction;
    
    AMCalculatorItem *item13 = [AMCalculatorItem itemWithTitle:@"0" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item14 = [AMCalculatorItem itemWithTitle:@"/" andType:AMCalculatorItemTypeNumber];
    AMCalculatorItem *item15 = [AMCalculatorItem itemWithTitle:@"=" andType:AMCalculatorItemTypeNumber];
    
    AMCalculatorItem *item16 = [AMCalculatorItem itemWithTitle:@"+" andType:AMCalculatorItemTypeSymbol];
    item16.operationType = AMArithmeticOperationAddition;
    
    AMCalculatorItem *item17 = [AMCalculatorItem itemWithTitle:@"Clean" andType:AMCalculatorItemTypeCleanAll];
    item17.operationType = AMCalculatorItemTypeCleanAll;
    
    AMCalculatorItem *item18 = [AMCalculatorItem itemWithTitle:@"<<" andType:AMCalculatorItemTypeCleanOneSymbol];
    AMCalculatorItem *item19 = [AMCalculatorItem itemWithTitle:@"+/-" andType:AMCalculatorItemTypeChangeSign];
    NSArray *itemsArray = @[item0, item1, item2, item3, item4, item5, item6, item7, item8, item9, item10, item11, item12, item13, item14, item15, item16, item17, item18, item19];
    return [NSMutableArray arrayWithArray:itemsArray];
}

#pragma mark - Actions

- (void)cleanOneSymbol
{
    if (![self isExpressionEmpty]) {
        NSString *expression = [self.expressionItem.title substringToIndex:[self.expressionItem.title length]-1];
        if ([self isSymbol:[self lastSymbolInExpression]]) {
            [self removeLastOperation];
        }
        self.expressionItem.title = [NSString stringWithString:expression];
    }
}

- (void)cleanExpressionLabel
{
    if (![self isExpressionEmpty]) {
        self.expressionItem.title = @"";
        [self.calculator.operations removeAllObjects];
    }
}

- (void)changeSign
{
    if (![self isOperationsEmpty] || [self isExpressionEmpty]) {
        return;
    }
    if ([self.expressionItem.title hasPrefix:@"-"]) {
        self.expressionItem.title = [self.expressionItem.title substringFromIndex:1];
    } else {
        NSString *expression = @"-";
        self.expressionItem.title = [expression stringByAppendingString:self.expressionItem.title];
    }
}

#pragma mark - Update Label

- (void)reloadFirstItem
{
    [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
}

- (void)updateLabelWithItem:(AMCalculatorItem *)item
{
    NSString *title = item.title;
    
    if (![self isEqualSymbol:title]) {
        [self updateExprssionWithCalculatorItem:item];
    } else if (![self isExpressionLabelZero] && ![self isExpressionEmpty]){
        [self updateLabelAfterCalculation];
    }
}

- (void)updateLabelAfterCalculation
{
    if (![self isOperationsEmpty]) {
        __weak typeof(self)weakSelf = self;
        [self.calculator performArithmeticalOperationWithExpression:self.expressionItem.title withCompletion:^(AMRationalFraction *resultFraction) {
            
            NSString *resultLabel = [resultFraction stringFromRationalFraction];
            weakSelf.expressionItem.title = [NSString stringWithString:resultLabel];
            [weakSelf.calculator.operations removeAllObjects];
        }];
    } else {
        AMRationalFraction *fraction = [self.expressionItem.title fractionValue];
        [fraction reduceFraction];
        self.expressionItem.title = [NSString stringWithString:[fraction stringFromRationalFraction]];
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
        if ([self isZero:self.expressionItem.title]) {
            self.expressionItem.title = @"";
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

#pragma  mark - Helper Methods

- (void)removeLastOperation
{
    if (![self isOperationsEmpty]) {
        [self.calculator.operations removeObjectAtIndex:self.calculator.operations.count - 1 ];
    }
}

- (void)addSymbolToExpression:(NSString *)symbol
{
    self.expressionItem.title = [self.expressionItem.title stringByAppendingString:symbol];
}

- (NSString *)lastSymbolInExpression
{
    if ([self isExpressionEmpty]) {
        return nil;
    }
    NSRange lastSymbolRange;
    lastSymbolRange.length = 1;
    lastSymbolRange.location = [self.expressionItem.title length]-1;
    
    return [self.expressionItem.title substringWithRange:lastSymbolRange];
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
    return !self.expressionItem.title.length;
}

- (BOOL)isOperationsEmpty
{
    return !self.calculator.operations.count;
}
- (BOOL)isCorrectPositionForZero
{
    return [self isCorrectPositionForSymbol] && ![self isExpressionLabelZero];
}

- (BOOL)isExpressionLabelZero
{
    return [self.expressionItem.title isEqualToString:@"0"];
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
        NSCharacterSet *expressionSet = [NSCharacterSet characterSetWithCharactersInString:self.expressionItem.title];
        NSRange dividingSymbolRange = [kDividingCharacter rangeOfCharacterFromSet:expressionSet];
        return dividingSymbolRange.location == NSNotFound;
    }
    AMArithmeticOperation *lastOperation = [self.calculator.operations objectAtIndex:self.calculator.operations.count -1];
    NSString *lastSymbol = lastOperation.symbol;
    NSRange lastSymbolRange = [self.self.expressionItem.title rangeOfString:lastSymbol options:NSBackwardsSearch];
    NSString *string = [self.expressionItem.title substringFromIndex:lastSymbolRange.location];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:string];
    NSRange dividingSymbolRange = [kDividingCharacter rangeOfCharacterFromSet:stringSet];
    return dividingSymbolRange.location == NSNotFound;
}

@end