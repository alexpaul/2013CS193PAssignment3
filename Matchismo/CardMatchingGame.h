//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Alex Paul on 2/2/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Deck.h"

@interface CardMatchingGame : NSObject

//  Designated Initializer 
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck cardMatchMode:(NSUInteger)mode;

- (void)flipCardAtIndex:(NSUInteger)index;
- (void)playSetCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)removeCardFromGame:(Card *)card;
- (NSMutableArray *)allCardsInPlay;
- (Card *)drawCardFromCurrentDeck;
- (void)addCardToCurrentGamePlay:(Card *)card;

@property (nonatomic, readonly) int score;
@property (nonatomic, copy) NSString *resultsString;

@end
