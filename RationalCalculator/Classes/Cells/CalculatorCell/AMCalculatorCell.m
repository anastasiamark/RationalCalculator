//
//  AMCalculatorCell.m
//  RationalCalculator
//
//  Created by Mark on 12.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMCalculatorCell.h"

#import "AMCalculatorItem.h"

@interface AMCalculatorCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIColor *savedBackgroundColor;

@end

@implementation AMCalculatorCell

#pragma mark - Accessors

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    self.backgroundColor = self.isHighlighted ? [UIColor colorWithRed:51.f/255.f green:51.f/255.f blue:51.f/255.f alpha:0.3f] : self.savedBackgroundColor;
}

#pragma mark - Lifecycle

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.layer.cornerRadius = 5.f;
}

#pragma mark - Actions

- (void)configureWithCalculatorItem:(AMCalculatorItem *)calculatorItem
{
    self.titleLabel.text = calculatorItem.title;
    
    if (calculatorItem.type == AMCalculatorItemTypeExpression) {
        
        self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:40.f];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor darkGrayColor];
        
    } else if (calculatorItem.type == AMCalculatorItemTypeSymbol) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor orangeColor];
    } else if (calculatorItem.type == AMCalculatorItemTypeCleanAll || calculatorItem.type == AMCalculatorItemTypeCleanOneSymbol || calculatorItem.type == AMCalculatorItemTypeChangeSign){
        self.backgroundColor = [UIColor grayColor];
    } else {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    if (!self.savedBackgroundColor) {
        self.savedBackgroundColor = self.backgroundColor;
    }
}

@end
