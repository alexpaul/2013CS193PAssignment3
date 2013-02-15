//
//  Deck.m
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "Deck.h"
#import "Card.h"

@interface Deck()
//  Private Properties
@property (nonatomic, strong) NSMutableArray *cards; 
@end

@implementation Deck

//  Lazy Instantiation in Getter
- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards; 
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (card != nil) {
        if (atTop) {
            [self.cards insertObject:card atIndex:0];
        }else{
            [self.cards addObject:card]; 
        }
    }
}

- (Card*)drawRandomCard
{
    Card *randomCard = nil;
    
    if (self.cards.count != 0) {
        unsigned index = arc4random() % self.cards.count;
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard; 
}

@end
