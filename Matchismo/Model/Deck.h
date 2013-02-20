//
//  Deck.h
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card; 

@interface Deck : NSObject

@property (nonatomic, readonly) NSMutableArray *cards;

//  Public Methods
- (void) addCard:(Card *)card atTop:(BOOL)atTop;
- (Card *)drawRandomCard; 

@end
