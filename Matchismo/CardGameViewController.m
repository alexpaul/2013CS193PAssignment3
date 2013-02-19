//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "CardGameViewController.h"
//#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResults.h"
#import "SettingsViewController.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipsCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) CardMatchingGame *game; 
@property (weak, nonatomic) IBOutlet UILabel *resultsLabel;
@property (weak, nonatomic) IBOutlet UISwitch *cardMatchingModeSwitch;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
//@property (nonatomic) int cardMatchMode;
@property (nonatomic, strong) SettingsViewController *settings; 
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (nonatomic) int visibleCellsCount;

//  Game Results
@property (nonatomic, strong) GameResults *gameResult; 

//  Keeps track of the flips history
@property (nonatomic, strong) NSMutableArray *flipsHistoryArray;
@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1; 
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return self.startingCardCount; // in the homework you will want to ask the game how many cards are currently in play
    
    if ([[self.cardCollectionView visibleCells] count] == 0) {
        return self.startingCardCount;
    }else{
        NSLog(@"There are %d cards in play.", [[self.game allCardsInPlay] count]);
        return [[self.game allCardsInPlay] count];
    }    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    if ([self.tabBarItem.title isEqualToString:@"Match"]) {
        CellIdentifier = @"PlayingCard";
    }else{
        CellIdentifier = @"SetCard"; 
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath]; //PlayingCard, SetCard
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    
    return cell; 
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    // abstract
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.visibleCellsCount = [[self.cardCollectionView visibleCells] count]; 
            
    self.historySlider.minimumValue = 0;
    self.historySlider.continuous = YES; 
    
    self.flipsHistoryArray = [[NSMutableArray alloc] init];
}

- (SettingsViewController *)settings
{
    if (!_settings) {
        _settings = [[SettingsViewController alloc] init];
    }
    return _settings; 
}

- (GameResults *)gameResult
{
    if (!_gameResult) {
        _gameResult = [[GameResults alloc] init];
    }
    return _gameResult; 
}

- (CardMatchingGame *)game
{    
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:12 usingDeck:[self createDeck] cardMatchMode:self.cardMatchingMode];
    }
    return _game; 
}

- (Deck *)createDeck {return nil;} // abstract 

- (void)updateUI
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        if (!card.isUnplayable && card.isFaceUp) {
            [self updateCell:cell usingCard:card animate:YES];
        }else{
            [self updateCell:cell usingCard:card animate:NO];
        }
        
        if (card.isUnplayable && card.isFaceUp) {
            if ([self.tabBarItem.title isEqualToString:@"Set"]) {
                [indexPaths addObject:indexPath];
            }
        }
    }
    if ([indexPaths count] != 0) {
        [self.cardCollectionView performBatchUpdates:^(void){
            for (NSIndexPath *indexPath in indexPaths) {
                Card *card = [self.game cardAtIndex:indexPath.item];
                [self.game removeCardFromGame:card]; // from dataSource
            }
            [self.cardCollectionView deleteItemsAtIndexPaths:indexPaths]; // from View
            [indexPaths removeAllObjects];
        }completion:nil];
    }
}

- (void)setFlipsCount:(int)flipsCount
{
    _flipsCount = flipsCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipsCount];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    //  Update the Game Result
    self.gameResult.score = self.game.score;
    self.gameResult.gamePlayed = self.tabBarItem.title; 
}

//  Gesture handler for the tap
- (IBAction)flipCard:(UIGestureRecognizer *)gesture
{    
    //  Location of the tap in the collection coordinate system
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    
    //  Get the index path of the item tapped
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    //  Check that indexPath does indeed have a value and the tap was not on an empty space in the collection view
    if (indexPath) {        
        if ([self.tabBarItem.title isEqualToString:@"Match"]) {
            [self.game flipCardAtIndex:indexPath.item]; // Flips the card if it's a PlayingCard
        }else{ // Sets the Card if it's a SetCard
            [self.game playSetCardAtIndex:indexPath.item];
        }
        self.flipsCount++;
        [self updateUI];
    }
}

- (IBAction)dealNewDeck:(UIButton *)sender
{
    NSLog(@"card match mode is %d", self.cardMatchingMode);
        
    self.game = nil;
    
    self.gameResult = nil; 
    
    [self updateUI];
        
    self.flipsCount = 0;
    
    self.resultsLabel.textColor = [UIColor blackColor];
    
    self.resultsLabel.text = @"New Game";
    
    self.visibleCellsCount = 0;

}

- (IBAction)cardMatchingMode:(UISwitch *)sender
{    
    [self dealNewDeck:nil]; 
}

- (IBAction)showFlipHistory:(UISlider *)sender
{
    NSLog(@"slider maximum value is %f", self.historySlider.maximumValue);
    
    NSLog(@"slider value is %f", sender.value);
        
    if ([self.flipsHistoryArray count] != 0 && (sender.value != sender.maximumValue)) {
        self.resultsLabel.textColor = [UIColor lightGrayColor];
        self.resultsLabel.text = self.flipsHistoryArray[(int)sender.value];
    }
}

@end
