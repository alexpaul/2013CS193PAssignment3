//
//  PlayingCard.h
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank; 

@end
