//
//  AMCalculatorCell.m
//  RationalCalculator
//
//  Created by Eugenity on 12.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import "AMCalculatorCell.h"

#import "AMCalculatorItem.h"

@interface AMCalculatorCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation AMCalculatorCell

#pragma mark - Actions

- (void)configureWithCalculatorItem:(AMCalculatorItem *)calculatorItem
{
    self.titleLabel.text = calculatorItem.title;
}

@end
