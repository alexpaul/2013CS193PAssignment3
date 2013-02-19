//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Alex Paul on 2/14/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h" 
#import "PlayingCardCollectonViewCell.h"

@implementation PlayingCardGameViewController


- (NSUInteger)startingCardCount
{
    return 22;
}

- (NSUInteger)cardMatchingMode
{
    return 2; 
}

- (Deck *)createDeck
{
    return[[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    //  Introspection - only if this class is PlayingCardCollectionViewCell
    if ([cell isKindOfClass:[PlayingCardCollectonViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectonViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.suit = playingCard.suit;
            playingCardView.rank = playingCard.rank;
            if (animate == YES) {
                [UIView transitionWithView:playingCardView duration:0.5
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    //  Togggle the face of the card up and down with animation
                                    playingCardView.faceUp = playingCard.isFaceUp;
                                }
                                completion:NULL];
            }else{ // no animation
                playingCardView.faceUp = playingCard.isFaceUp; 
            }
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

@end
 