//
//  SetCard.m
//  Matchismo
//
//  Created by Alex Paul on 2/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()
@end

@implementation SetCard

+ (NSArray *)validCharacters
{
    return @[@"▲", @"■", @"●"]; // @"▲", @"■", @"●"
}

+ (NSArray *)validColors
{
    return @[[UIColor redColor],[UIColor greenColor],[UIColor blueColor]]; // [UIColor redColor],[UIColor greenColor],[UIColor blueColor]
}

+ (NSArray *)validShading
{
    return @[@"no fill", @"fill", @"light shade"]; 
}

- (void)setNumberOfSymbols:(NSUInteger)numberOfSymbols
{
    if (numberOfSymbols <= 3) {
        _numberOfSymbols = numberOfSymbols;
    }
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@, %@, %@, %d", self.symbol, self.shading, self.color, self.numberOfSymbols];
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    NSLog(@"inside match: SetCard"); 
    
    //  Set Card Game Rules: 
    //  They all have the same number, or they have three different numbers. (number)
    //  They all have the same symbol, or they have three different symbols. (symbol)
    //  They all have the same shading, or they have three different shadings. (shading)
    //  They all have the same color, or they have three different colors. (color)
    //  If you can sort a group of three cards into "Two of ____ and one of _____," then it is not a set.
    
    if ([otherCards count] == 2) {
        SetCard *otherCard1 = otherCards [0];
        SetCard *otherCard2 = otherCards [1];
        
        BOOL isNOTASet;
        
        if (((self.numberOfSymbols == otherCard1.numberOfSymbols) && (self.numberOfSymbols != otherCard2.numberOfSymbols)) ||
            ((self.numberOfSymbols == otherCard2.numberOfSymbols) && (self.numberOfSymbols != otherCard1.numberOfSymbols))||
            ((otherCard1.numberOfSymbols == otherCard2.numberOfSymbols) && (self.numberOfSymbols != otherCard1.numberOfSymbols)))
        {
            isNOTASet = YES;
            NSLog(@"number mismatch");
        }
        else if (([self.symbol isEqualToString:otherCard1.symbol] && !([self.symbol isEqualToString:otherCard2.symbol])) ||
                 ([self.symbol isEqualToString:otherCard2.symbol] && !([self.symbol isEqualToString:otherCard1.symbol])) ||
                  ([otherCard1.symbol isEqualToString:otherCard2.symbol] && !([self.symbol isEqualToString:otherCard1.symbol])))
        {
            isNOTASet = YES;
            NSLog(@"symbol mismatch");
        }
        else if (([self.shading isEqualToString:otherCard1.shading] && !([self.shading isEqualToString:otherCard2.shading]))||
                 ([self.shading isEqualToString:otherCard2.shading] && !([self.shading isEqualToString:otherCard1.shading])) ||
                 ([otherCard1.shading isEqualToString:otherCard2.shading] && !([self.shading isEqualToString:otherCard1.shading])))
        {
            isNOTASet = YES;
            NSLog(@"shading mismatch");
        }
        else if (((self.color == otherCard1.color) && (self.color != otherCard2.color))||
                 ((self.color == otherCard2.color) && (self.color != otherCard1.color)) ||
                 ((otherCard1.color == otherCard2.color) && (self.color != otherCard1.color)))
        {
            isNOTASet = YES;
            NSLog(@"color mismatch");
        }
        
        if (isNOTASet == YES) {
            NSLog(@"SET NOT Found!");
        }else{
            NSLog(@"SET Found!");
            score = 3;
        }
    }
    
    return score;
}

@end
