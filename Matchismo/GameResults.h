//
//  GameResults.h
//  Matchismo
//
//  Created by Alex Paul on 2/8/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameResults : NSObject

@property (nonatomic, readonly) NSDate *start;
@property (nonatomic, readonly) NSDate *end;
@property (nonatomic, readonly) NSTimeInterval duration; 
@property (nonatomic) int score;
@property (nonatomic, strong) NSString *gamePlayed; 

+(NSArray *)allGameResults; // of GameResults

@end
