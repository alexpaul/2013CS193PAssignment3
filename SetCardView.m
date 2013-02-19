//
//  SetCardView.m
//  SetCardViewer
//
//  Created by Alex Paul on 2/16/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define INSET 10 // of shape from edge
#define LINE_WIDTH 2 // of symblol
#define CORNER_RADIUS 12 // of rounded rect

- (void)drawRect:(CGRect)rect
{
    //  Drawing Code
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:CORNER_RADIUS];
    
    [roundedRect addClip];
    
    if (self.faceUp) {
        [[[UIColor lightGrayColor] colorWithAlphaComponent:0.9] setFill];
    }else{
        [[UIColor whiteColor] setFill];
    }
    
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    //  Fixed Width and Height of Rectangle
    CGFloat rectWidth = (self.bounds.size.width)-INSET*2;
    CGFloat rectHeight = ((self.bounds.size.height)-(INSET*4))/3;
    
    //  x, rectWidth and rectHeight are constant, y varies based on the number of symbols on the set card
    if ([self.shape isEqualToString:@"Oval"]) {
        [self drawOvalWithRectWidth:rectWidth rectHeight:rectHeight];
    }else if ([self.shape isEqualToString:@"Diamond"]){
        [self drawDiamondWithRectWidth:rectWidth rectHeight:rectHeight];
    }else if ([self.shape isEqualToString:@"Squiggle"]){
        [self drawSquiggleWithRectWidth:rectWidth rectHeight:rectHeight];
    }
}

- (void)drawSquiggleWithRectWidth:(CGFloat)rectWidth rectHeight:(CGFloat)rectHeight
{
    //  Create an instance of bezierPath instead of in a bezierPathWithRect
    //  This will make it easier to fill and stroke without worrrying about the hidding the CGRect fill and stroke as well
    UIBezierPath *squiggle = [UIBezierPath bezierPath]; //[UIBezierPath bezierPathWithRect:aCGRect];
        
    //  Create the squiggle
    [self createSquiggle:squiggle inRectWidth:rectWidth andRectHeight:rectHeight];
    
    if (self.number == 1) {
        [self pushContextToTranslateWithX:INSET yCoordinate:self.bounds.size.height/2-(rectHeight/2)];
        [self setFillAndStrokeColorForShape:squiggle];
        [self popContext];
    }else if (self.number == 2){
        [self pushContextToTranslateWithX:INSET yCoordinate:(self.bounds.size.height/2)-rectHeight];
        [self setFillAndStrokeColorForShape:squiggle];
        [self popContext];
        
        [self pushContextToTranslateWithX:INSET yCoordinate:(self.bounds.size.height/2)+(INSET/2)];
        [self setFillAndStrokeColorForShape:squiggle];
        [self popContext];
        
    }else if (self.number == 3){
        [self pushContextToTranslateWithX:INSET yCoordinate:INSET];
        [self setFillAndStrokeColorForShape:squiggle];
        [self popContext];
        
        [self pushContextToTranslateWithX:INSET yCoordinate:self.bounds.size.height/2-(rectHeight/2)];
        [self setFillAndStrokeColorForShape:squiggle];
        [self popContext];
        
        [self pushContextToTranslateWithX:INSET yCoordinate:self.bounds.size.height-(INSET+rectHeight)];
        [self setFillAndStrokeColorForShape:squiggle];
        [self popContext];
    }
}

- (void)createSquiggle:(UIBezierPath *)squiggle inRectWidth:(CGFloat)rectWidth andRectHeight:(CGFloat)rectHeight
{
    CGFloat thirdOFRectHeight = rectHeight/3;
    
    squiggle.lineWidth = LINE_WIDTH;
    
    //  Move to Point 
    [squiggle moveToPoint:CGPointMake(0, thirdOFRectHeight)];
    
    //  Add Cubic Curve
    [squiggle addCurveToPoint:CGPointMake(rectWidth, 0) controlPoint1:CGPointMake((rectWidth/2)-thirdOFRectHeight, -thirdOFRectHeight) controlPoint2:CGPointMake((rectWidth/2)+thirdOFRectHeight, rectHeight/2)];
    
    //  Add Line 
    [squiggle addLineToPoint:CGPointMake(rectWidth, rectHeight-thirdOFRectHeight)];
    
    //  Add Cubic Curve
    [squiggle addCurveToPoint:CGPointMake(0, rectHeight) controlPoint1:CGPointMake((rectWidth/2)+thirdOFRectHeight, rectHeight+thirdOFRectHeight) controlPoint2:CGPointMake((rectWidth/2)-thirdOFRectHeight, thirdOFRectHeight)];
    
    //  Close the Path with a line
    [squiggle closePath];
}

- (void)pushContextToTranslateWithX:(CGFloat)xCoordinate yCoordinate:(CGFloat)yCoordinate
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, xCoordinate, yCoordinate);
}

- (void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext()); 
}

- (void)drawDiamondWithRectWidth:(CGFloat)rectWidth rectHeight:(CGFloat)rectHeight
{
    CGFloat verticalCenter = (self.bounds.size.height)/2;
    
    UIBezierPath *diamond = [[UIBezierPath alloc] init];
    
    if (self.number == 1) {
        UIBezierPath *diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(INSET, (self.bounds.size.height)/2)];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter-(rectHeight/2))];
        [diamond addLineToPoint:CGPointMake(INSET+rectWidth, (self.bounds.size.height)/2)];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter+(rectHeight/2))];
        [diamond closePath];
        diamond.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:diamond];
    }else if (self.number == 2){
        diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(INSET, verticalCenter-((INSET/2)+(rectHeight/2)))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter-((INSET/2)+rectHeight))];
        [diamond addLineToPoint:CGPointMake(INSET+rectWidth, verticalCenter-((INSET/2)+(rectHeight/2)))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter-(INSET/2))];
        [diamond closePath];
        diamond.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:diamond];
        
        diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(INSET, verticalCenter+((INSET/2)+(rectHeight/2)))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter+(INSET/2))];
        [diamond addLineToPoint:CGPointMake(INSET+rectWidth, verticalCenter+((INSET/2)+(rectHeight/2)))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter+((INSET/2)+rectHeight))];
        [diamond closePath];
        diamond.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:diamond];
    }else if (self.number == 3){
        diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(INSET, INSET+(rectHeight/2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, INSET)];
        [diamond addLineToPoint:CGPointMake(INSET+rectWidth, INSET+(rectHeight/2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, INSET+rectHeight)];
        [diamond closePath];
        diamond.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:diamond];
        
        diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(INSET, (self.bounds.size.height)/2)];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter-(rectHeight/2))];
        [diamond addLineToPoint:CGPointMake(INSET+rectWidth, (self.bounds.size.height)/2)];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, verticalCenter+(rectHeight/2))];
        [diamond closePath];
        diamond.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:diamond];
        
        diamond = [[UIBezierPath alloc] init];
        [diamond moveToPoint:CGPointMake(INSET, self.bounds.size.height-(INSET+rectHeight/2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, self.bounds.size.height-(INSET+rectHeight))];
        [diamond addLineToPoint:CGPointMake(INSET+rectWidth, self.bounds.size.height-(INSET+rectHeight/2))];
        [diamond addLineToPoint:CGPointMake((self.bounds.size.width)/2, self.bounds.size.height-INSET)];
        [diamond closePath];
        diamond.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:diamond];
    }
}

- (void)drawOvalWithRectWidth:(CGFloat)rectWidth rectHeight:(CGFloat)rectHeight
{
    NSUInteger symbol = self.number;
    CGFloat verticalCenter = (self.bounds.size.height)/2;
    
    if (symbol == 1) {
        CGRect myRect1 = CGRectMake(INSET, INSET+rectHeight+INSET, rectWidth, rectHeight);
        
        //  Draw Oval in Rect
        UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:myRect1];
        oval.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:oval];
    }else if (symbol == 2){
        CGRect myRect1 = CGRectMake(INSET, verticalCenter-((INSET/2)+rectHeight), rectWidth, rectHeight);
        CGRect myRect2 = CGRectMake(INSET, verticalCenter+(INSET/2), rectWidth, rectHeight);
        
        //  Draw Oval in Rect1
        UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:myRect1];
        oval.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:oval];
        
        //  Draw Oval in Rect2
        oval = [UIBezierPath bezierPathWithOvalInRect:myRect2];
        oval.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:oval];
    }else if (symbol == 3){
        CGRect myRect1 = CGRectMake(INSET, INSET, rectWidth, rectHeight);
        CGRect myRect2 = CGRectMake(INSET, INSET+rectHeight+INSET, rectWidth, rectHeight);
        CGRect myRect3 = CGRectMake(INSET, INSET+(rectHeight+INSET)*2, rectWidth, rectHeight);
        
        //  Draw Oval in Rect1
        UIBezierPath *oval = [UIBezierPath bezierPathWithOvalInRect:myRect1];
        oval.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:oval];
        
        //  Draw Oval in Rect2
        oval = [UIBezierPath bezierPathWithOvalInRect:myRect2];
        oval.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:oval];
        
        //  Draw Oval in Rect3
        oval = [UIBezierPath bezierPathWithOvalInRect:myRect3];
        oval.lineWidth = LINE_WIDTH;
        [self setFillAndStrokeColorForShape:oval];
    }
}

//  Set the render colors
- (void)setFillAndStrokeColorForShape:(UIBezierPath *)shape
{
    if ([self.shade isEqualToString:@"Solid"]) {
        [self.color setFill];
        [self.color setStroke];
        [shape fill]; [shape stroke];
    }else if ([self.shade isEqualToString:@"Unfill"]){
        [self.color setStroke];
        [shape fill]; [shape stroke];
    }else if ([self.shade isEqualToString:@"Striped"]){
        [[self.color colorWithAlphaComponent:0.2] setFill];
        [self.color setStroke];
        [shape fill]; [shape stroke];
    }
}

#pragma mark - Initialization
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup
{
    //  Do initializations here
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setShade:(NSString *)shade
{
    _shade = shade;
    [self setNeedsDisplay];
}

- (void)setShape:(NSString *)shape
{
    _shape = shape;
    [self setNeedsDisplay]; 
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay]; 
}

@end
