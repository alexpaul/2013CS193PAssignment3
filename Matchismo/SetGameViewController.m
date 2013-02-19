//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Alex Paul on 2/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"

@implementation SetGameViewController

#define CARD_MATCHING_MODE 3

- (NSUInteger)startingCardCount
{
    return 12;
}

- (NSUInteger)cardMatchingMode
{
    return CARD_MATCHING_MODE;
}

- (Deck *)createDeck
{
    return[[SetCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    //  Introspection only if this class responds to SetCardCollectionViewCell
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.number = setCard.number;
            setCardView.color = setCard.color;
            setCardView.shade = setCard.shade;
            setCardView.shape = setCard.shape;
            setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
            setCardView.faceUp = setCard.isFaceUp;
        }
    }
}

@end
