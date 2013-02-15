//
//  GameResults.m
//  Matchismo
//
//  Created by Alex Paul on 2/8/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "GameResults.h"

@interface GameResults()
@property (nonatomic, readwrite) NSDate *start;
@property (nonatomic, readwrite) NSDate *end; 
@end

@implementation GameResults

#define START_KEY @"StartKey"
#define END_KEY @"EndDate"
#define SCORE_KEY @"ScoreKey"
#define ALL_RESULTS_KEY @"GameResult_All"
#define GAME_PLAYED @"Game_Played"

+ (NSArray *)allGameResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id pList in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        GameResults *result = [[GameResults alloc] initFromPropertyList:pList];
        [allGameResults addObject:result];
    }
    return allGameResults; 
}

- (id)initFromPropertyList:(NSDictionary *)pList
{
    self = [self init];
    if (self) {
        _start = [pList objectForKey:START_KEY];
        _end = [pList objectForKey:END_KEY];
        _score = [[pList objectForKey:SCORE_KEY] intValue];
        _gamePlayed = [pList objectForKey:GAME_PLAYED];
        if (!_start || !_end) self = nil; 
    }
    return self;
}

// Designated Initializer
- (id)init
{
    self = [super init];
    
    if (self) {
        _start = [NSDate date];
        _end = _start; 
    }
    return self;
}

- (void)synchronize
{ 
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    
    if (!mutableGameResultsFromUserDefaults) mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    
    mutableGameResultsFromUserDefaults[[self.start description]]= [self asPropertyList];
    
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{START_KEY : self.start, END_KEY : self.end, SCORE_KEY : @(self.score), GAME_PLAYED : self.gamePlayed};
}

- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}

- (NSString *)gamePlayed
{
    if (!_gamePlayed) {
        _gamePlayed = [[NSString alloc] init];
    }
    return _gamePlayed; 
}

- (void)setScore:(int)score
{
    _score = score;
    self.end = [NSDate date];
    [self synchronize];
}

@end
