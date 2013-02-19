//
//  SetCardView.h
//  SetCardViewer
//
//  Created by Alex Paul on 2/16/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic, strong) UIColor *color; // of symbol on set card (red, green or purple)
@property (nonatomic) NSUInteger number; // of symbols (1, 2 or 3)
@property (nonatomic, strong) NSString *shade; // of symbol (solid, striped, unfill)
@property (nonatomic, strong) NSString *shape; // (squiggle, diamond, oval)
@property (nonatomic) BOOL faceUp; 

@end
