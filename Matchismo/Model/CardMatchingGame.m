//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Alex Paul on 2/2/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "SetCard.h"

@interface CardMatchingGame()
@property (readwrite, nonatomic) int score;
@property (nonatomic, strong) NSMutableArray *cards; // of Card
@property (nonatomic, strong) Deck *currentDeck;

// Flip count keeps track of remaining flips
@property (nonatomic) int flipsRemaining;

// Card Match Mode
@property (nonatomic) int cardMatchMode;

// A mutable array to hold the other cards for matching
@property (nonatomic, strong) NSMutableArray *holdCardsForMatching;
@end    

@implementation CardMatchingGame

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1 

- (Deck *)currentDeck
{
    if (!_currentDeck) _currentDeck = [[Deck alloc] init];
    return _currentDeck; 
}

- (NSMutableArray *)allCardsInPlay
{
    NSMutableArray *allCards = [[NSMutableArray alloc] initWithArray:self.cards];
    return allCards;
}

- (void)possibleSetsInCurrentGamePlay
{
    for (Card *card in self.cards) {
        for (int otherCard1Index = 1; otherCard1Index <= [self.cards count]-2; otherCard1Index++) {
            for (int otherCard2Index = 2; otherCard2Index <= [self.cards count]-1; otherCard2Index++) { //??????
                int match = [card match:@[[self cardAtIndex:otherCard1Index], [self cardAtIndex:otherCard2Index]]];
                if (match != 0) NSLog(@"SET FOUND");
                //NSLog(@"Card %@, Other1%@, Other2%@", card.contents, [self cardAtIndex:otherCard1Index].contents, [self cardAtIndex:otherCard2Index].contents);
            }
        }
    }
}

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSMutableArray *)holdCardsForMatching
{
    if (!_holdCardsForMatching) {
        _holdCardsForMatching = [[NSMutableArray alloc] init];
    }
    return _holdCardsForMatching; 
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck cardMatchMode:(NSUInteger)mode
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            }else{
                self = nil;
                break; 
            }
        }
        self.flipsRemaining = mode;
        self.cardMatchMode = mode;
        
        //  Save Deck
        self.currentDeck = deck; 
    }
    return self; 
}

- (Card *)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (void)removeCardFromGame:(Card *)card
{    
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *)card;
        NSLog(@"%@ %@ with %d shapes is getting deleted.",setCard.shade, setCard.shape, setCard.number);
        [self.cards removeObject:card];
    }
            
    NSLog(@"After deletion in Model there are %d cards", [self.cards count]);  
}

- (void)addCardToCurrentGamePlay:(Card *)card
{
    [self.cards addObject:card];
}

- (Card *)drawCardFromCurrentDeck
{
    Card *card = nil;
        
    if ([self.currentDeck.cards count] != 0) {
        card = [self.currentDeck drawRandomCard];
    }
    return card;
}

- (void)playSetCardAtIndex:(NSUInteger)index
{
    SetCard *card = (SetCard *)[self cardAtIndex:index];
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable && (self.flipsRemaining == 1)) {
                    self.flipsRemaining = self.cardMatchMode;
                    NSLog(@"there are %d setcards in the array.", [self.holdCardsForMatching count]); 
                    int matchScore = [card match:[NSArray arrayWithArray:self.holdCardsForMatching]];
                    
                    if (matchScore) {
                        card.unPlayable = YES;
                        
                        // Mark all the other cards in the holdCardsForMatching array unplayable since a match was found
                        for (Card *otherCards in self.holdCardsForMatching) {
                            otherCards.unPlayable = YES;
                        }
                        
                        self.score += matchScore * MATCH_BONUS;
                        
                    }else{
                        for (Card *otherCard in self.holdCardsForMatching) {
                            otherCard.faceUp = NO;
                        }
                        
                        self.score -= MISMATCH_PENALTY;
                    }
                    [self.holdCardsForMatching removeAllObjects];
                    break;
                }
                self.resultsString = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
        
        
        if (card.faceUp && !card.isUnplayable) {
            NSLog(@"Saving card for matching.....");
            [self.holdCardsForMatching addObject:card];
            self.flipsRemaining--;
            NSLog(@"flips remaining %d", self.flipsRemaining);
        }
    }
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    
    Card *card = [self cardAtIndex:index];
    
    //NSLog(@"flips remaining %d", self.flipsRemaining);
    
    if (card && !card.isUnplayable) {
        if (!card.isFaceUp) {
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable && (self.flipsRemaining == 1)) {
                    self.flipsRemaining = self.cardMatchMode;
                    NSLog(@"in matchScore block");
                    
                    int matchScore = [card match:[NSArray arrayWithArray:self.holdCardsForMatching]];
                    
                    if (matchScore) {
                        card.unPlayable = YES;
                        
                        // Mark all the other cards in the holdCardsForMatching array unplayable since a match was found
                        for (Card *otherCards in self.holdCardsForMatching) {
                            otherCards.unPlayable = YES;
                        }
                        
                        NSMutableArray *holdMatches = [[NSMutableArray alloc] init];
                        if ([self.holdCardsForMatching count] == 2) {
                            PlayingCard *card1 = self.holdCardsForMatching[0];
                            PlayingCard *card2 = self.holdCardsForMatching[1];
                            PlayingCard *ourCard = (PlayingCard *)card;
                            
                            // Check for suit match
                            if ([card1.suit isEqualToString:card2.suit] && [ourCard.suit isEqualToString:card1.suit])
                            {
                                [holdMatches addObject:card1];
                                [holdMatches addObject:card2];
                                [holdMatches addObject:ourCard];
                                
                            }
                            else if ([card1.suit isEqualToString:card2.suit] || card1.rank == card2.rank) {
                                [holdMatches addObject:card1];
                                [holdMatches addObject:card2];
                                
                            }
                            else if ([card1.suit isEqualToString:ourCard.suit] || card1.rank == ourCard.rank) {
                                [holdMatches addObject:card1];
                                [holdMatches addObject:ourCard];
                                
                            }else if ([card2.suit isEqualToString:ourCard.suit] || card2.rank == ourCard.rank) {
                                [holdMatches addObject:card2];
                                [holdMatches addObject:ourCard];
                            }
                            
                            NSMutableString *aString = [[NSMutableString alloc] init];
                            for (PlayingCard *matchCards in holdMatches) {
                                [aString appendString:matchCards.contents];
                                [aString appendString:@", "];
                            }
                            [aString appendString:@" match."];
                            self.resultsString = aString;
                            
                            self.score += matchScore * MATCH_BONUS;
                            
                        }else{
                            self.score += matchScore * MATCH_BONUS;
                            self.resultsString = [NSString stringWithFormat:@"Matched %@ and %@ for %d points", card.contents, otherCard.contents, MATCH_BONUS];
                        }
                        
                    }else{
                        for (Card *otherCard in self.holdCardsForMatching) {
                            otherCard.faceUp = NO;
                        }
                        self.score -= MISMATCH_PENALTY;
                        self.resultsString = [NSString stringWithFormat:@"%@ and %@ don't match! -%d!", card.contents, otherCard.contents, MISMATCH_PENALTY];
                    }
                    [self.holdCardsForMatching removeAllObjects];
                    break;
                }
                self.resultsString = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
        
        
        if (card.faceUp && !card.isUnplayable) {
            NSLog(@"inside hold for matching.");
            [self.holdCardsForMatching addObject:card];
            self.flipsRemaining--;
        }
    }
}


@end
