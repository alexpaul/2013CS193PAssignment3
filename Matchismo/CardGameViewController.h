//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic) NSUInteger startingCardCount; // abstract
@property (nonatomic) NSUInteger cardMatchingMode; // abstract
- (Deck *)createDeck; // abstract
- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate; // abstract

@end
