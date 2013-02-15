//
//  PlayingCard.m
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit; // Because we provide setter and getter

+ (NSArray *)validSuits
{
    return @[@"♠", @"♣", @"♥", @"♦"]; 
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {return [self rankStrings].count-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank; 
    }
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 2) {
        PlayingCard *otherCard1 = otherCards[0];
        PlayingCard *otherCard2 = otherCards[1];
        if ([otherCard1.suit isEqualToString:otherCard2.suit]) {
            score += 1;
        }else if(otherCard1.rank == otherCard2.rank){
            score += 4;
        }
        
        NSLog(@"scrore in if is %d", score);
        
    }
    
    for (Card *card in otherCards) {
        PlayingCard *otherCard = (PlayingCard *)card;
        if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        }else if(otherCard.rank == self.rank){
            score += 4;
        }
        NSLog(@"scrore in for is %d", score);    
    }
    
    NSLog(@"the outside score is %d", score); 
    
    return score; 
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit]; 
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit; 
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

@end
