//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Alex Paul on 2/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
            
    if (self) {
        for (NSString *shape in [SetCard validShapes]) {
            for (UIColor *color in [SetCard validColors]) {
                for (NSString *shade in [SetCard validShading]) {
                    for (int i = 1; i <= 3; i++) {
                        // Create 3 cards with 1, 2 and 3 symbols respectively
                        SetCard *card = [[SetCard alloc] init];
                        card.shape = shape;
                        card.color = color;
                        card.shade = shade;
                        card.number = i;
                        [self addCard:card atTop:NO];                         
                    }
                }
            }
        }
    }
    return self; 
}

@end
