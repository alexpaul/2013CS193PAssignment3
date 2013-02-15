//
//  SetCard.h
//  Matchismo
//
//  Created by Alex Paul on 2/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic, strong) UIColor *color; // of symbol on card (red, green or blue)
@property (nonatomic) NSUInteger numberOfSymbols; // of symbols on card (one, two or three)
@property (nonatomic, strong) NSString *symbol; // (triangle, circle or square)
@property (nonatomic, strong) NSString *shading; // (fill, no fill or dots)

+ (NSArray *)validCharacters; // (triangle, circle, square)
+ (NSArray *)validColors; // (red, blue, green)
+ (NSArray *)validShading; // (no fill, fill, light shade)

@end
