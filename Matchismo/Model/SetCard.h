//
//  SetCard.h
//  Matchismo
//
//  Created by Alex Paul on 2/9/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic, strong) UIColor *color; // of symbol on card (red, green or purple)
@property (nonatomic) NSUInteger number; // of symbols on card (one, two or three)
@property (nonatomic, strong) NSString *shape; // (squiggle, diamond or oval)
@property (nonatomic, strong) NSString *shade; // (solid, unfill or stiped)

+ (NSArray *)validShapes; // (diamond, oval, squiggle)
+ (NSArray *)validColors; // (red, blue, green)
+ (NSArray *)validShading; // (solid, unfill, striped)

@end
