//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Alex Paul on 1/25/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
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
@property (nonatomic) int cardMatchMode;
@property (nonatomic, strong) SettingsViewController *settings; 
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

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
    return self.startingCardCount; // in the homework you will want to ask the game how many cards are currently in play
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
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
    
    //self.cardMatchingModeSwitch.on = NO;
        
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
    self.cardMatchMode = (self.cardMatchingModeSwitch.on) ? 3 : 2;
    //self.cardMatchMode = (self.settings.gameModeSwitch.on) ? 3 : 2;
    
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck] cardMatchMode:self.cardMatchMode];
    }
    return _game; 
}

- (Deck *)createDeck {return nil;} // abstract 

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        if (!card.isUnplayable && card.isFaceUp) {
            [self updateCell:cell usingCard:card animate:YES];
        }else{
            [self updateCell:cell usingCard:card animate:NO];
        }
    }
    
    /*
    self.resultsLabel.textColor = [UIColor blackColor];
    self.resultsLabel.text = self.game.resultsString;
    
    if (self.game.resultsString != nil) {
        //  Save results match to flipsArray  
        [self.flipsHistoryArray addObject:self.game.resultsString];
    }
    
    //  Set maximum value of slider
    self.historySlider.maximumValue = [self.flipsHistoryArray count];*/
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
    //self.cardMatchingModeSwitch.enabled = NO;
    
    //  Location of the tap in the collection coordinate system
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    
    //  Get the index path of the item tapped
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    //  Check that indexPath does indeed have a value and the tap was not on an empty space in the collection view
    if (indexPath) {        
        if ([self.tabBarItem.title isEqualToString:@"Match"]) {
            [self.game flipCardAtIndex:indexPath.item];
        }else{
            //[self.game setCardAtIndex:index];
        }
        self.flipsCount++;
        [self updateUI];
    }
}

- (IBAction)dealNewDeck:(UIButton *)sender
{
    //self.cardMatchingModeSwitch.enabled = YES;
    
    //self.cardMatchMode = (self.settings.gameModeSwitch.on) ? 3 : 2;
        
    NSLog(@"card match mode is %d", self.cardMatchMode);
        
    self.game = nil;
    
    self.gameResult = nil; 
    
    [self updateUI];
    
    self.flipsCount = 0;
    
    self.resultsLabel.textColor = [UIColor blackColor];
    
    self.resultsLabel.text = @"New Game";

}

- (IBAction)cardMatchingMode:(UISwitch *)sender
{
    self.cardMatchMode = (sender.on) ? 3 : 2;
    
    [self dealNewDeck:nil]; 
    
    NSLog(@"card match mode is %d", self.cardMatchMode);

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
