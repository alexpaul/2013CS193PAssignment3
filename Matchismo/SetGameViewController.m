//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Alex Paul on 2/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"

#import "SetCard.h"

@interface SetGameViewController ()
@property (nonatomic, strong) SetCardDeck *setCardDeck;
@property (nonatomic, strong) CardMatchingGame *game; 
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation SetGameViewController

#define CARD_MATCHING_MODE 3

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[[SetCardDeck alloc] init] cardMatchMode:CARD_MATCHING_MODE];
    }
    return _game; 
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (SetCardDeck *)setCardDeck
{
    if (!_setCardDeck) {
        _setCardDeck = [[SetCardDeck alloc] init];
    }
    return _setCardDeck; 
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        SetCard *card = (SetCard *)[self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha =  card.isUnplayable ? 0.3 : 1.0;
        
        if (cardButton.selected) {
            [cardButton setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            [cardButton setBackgroundColor:[UIColor whiteColor]]; 
        }
                
        //  Add number of symbols to the card
        NSString *displaySymbol = card.symbol; 
        switch (card.numberOfSymbols) {
            case 1:
                break;
            case 2:
                displaySymbol = [card.symbol stringByAppendingString:card.symbol];
                break;
            case 3:
                displaySymbol = [NSString stringWithFormat:@"%@%@%@", card.symbol, card.symbol, card.symbol];
                break;
            default:
                break;
        }
        
        //  Add attributes: color and shading
        NSMutableAttributedString *mat = [[NSMutableAttributedString alloc] initWithString:displaySymbol];
        NSRange range = [displaySymbol rangeOfString:displaySymbol];
        
        if ([card.shading isEqualToString:@"fill"]) {
            [mat addAttribute:NSForegroundColorAttributeName value:card.color range:range];
            [mat addAttribute:NSStrokeWidthAttributeName value:@-5 range:range];
            [mat addAttribute:NSStrokeColorAttributeName value:card.color range:range];
        }else if ([card.shading isEqualToString:@"no fill"]){
            [mat addAttribute:NSForegroundColorAttributeName value:card.color range:range];
            [mat addAttribute:NSStrokeWidthAttributeName value:@12 range:range];
            [mat addAttribute:NSStrokeColorAttributeName value:card.color range:range];
        }else{ // light shade
            [mat addAttribute:NSForegroundColorAttributeName value:[card.color colorWithAlphaComponent:0.2] range:range];
            [mat addAttribute:NSStrokeWidthAttributeName value:@-5 range:range];
            [mat addAttribute:NSStrokeColorAttributeName value:card.color range:range];
        }
        
        [cardButton setAttributedTitle:mat forState:UIControlStateNormal];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //SetCardDeck *deck = [[SetCardDeck alloc] init];
        
//    NSMutableAttributedString *mat = [self.label.attributedText mutableCopy];
//    NSRange rangeOfString = [[self.label.attributedText string] rangeOfString:self.label.text];
//    [mat addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:rangeOfString];
//    self.label.attributedText = mat;
    
}

- (void)setup
{
    // Initialization that can't wait until viewDidLoad
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self; 
}

@end
