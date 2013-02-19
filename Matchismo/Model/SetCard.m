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

+ (NSArray *)validShapes
{
    return @[@"Squiggle", @"Diamond", @"Oval"]; // @"▲", @"■", @"●"
}

+ (NSArray *)validColors
{
    return @[[UIColor redColor],[UIColor greenColor],[UIColor purpleColor]]; // [UIColor redColor],[UIColor greenColor],[UIColor blueColor]
}

+ (NSArray *)validShading
{
    return @[@"Unfill", @"Solid", @"Striped"]; 
}

- (void)number:(NSUInteger)number
{
    if (number <= 3) {
        _number = number;
    }
}

- (NSString *)contents
{
    return [NSString stringWithFormat:@"%@, %@, %@, %d", self.shape, self.shade, self.color, self.number];
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
        
        if (((self.number == otherCard1.number) && (self.number != otherCard2.number)) ||
            ((self.number == otherCard2.number) && (self.number != otherCard1.number))||
            ((otherCard1.number == otherCard2.number) && (self.number != otherCard1.number)))
        {
            isNOTASet = YES;
            NSLog(@"number mismatch");
        }
        else if (([self.shape isEqualToString:otherCard1.shape] && !([self.shape isEqualToString:otherCard2.shape])) ||
                 ([self.shape isEqualToString:otherCard2.shape] && !([self.shape isEqualToString:otherCard1.shape])) ||
                  ([otherCard1.shape isEqualToString:otherCard2.shape] && !([self.shape isEqualToString:otherCard1.shape])))
        {
            isNOTASet = YES;
            NSLog(@"symbol mismatch");
        }
        else if (([self.shade isEqualToString:otherCard1.shade] && !([self.shade isEqualToString:otherCard2.shade]))||
                 ([self.shade isEqualToString:otherCard2.shade] && !([self.shade isEqualToString:otherCard1.shade])) ||
                 ([otherCard1.shade isEqualToString:otherCard2.shade] && !([self.shade isEqualToString:otherCard1.shade])))
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
