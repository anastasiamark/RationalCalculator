//
//  AMCalculatorCell.h
//  RationalCalculator
//
//  Created by Mark on 12.10.15.
//  Copyright © 2015 ThinkMobiles. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMCalculatorItem;

@interface AMCalculatorCell : UICollectionViewCell

- (void)configureWithCalculatorItem:(AMCalculatorItem *)calculatorItem;

@end
