//
//  GameResultsViewController.m
//  Matchismo
//
//  Created by Alex Paul on 2/8/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import "GameResultsViewController.h"
#import "GameResults.h"

@interface GameResultsViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (strong, nonatomic) NSMutableArray *sortResultsArray; 

@end

@implementation GameResultsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup]; 
    return self;
}

- (NSMutableArray *)sortResultsArray
{
    if (!_sortResultsArray) {
        _sortResultsArray = [[NSMutableArray alloc] init];
    }
    return _sortResultsArray; 
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup]; 
}

- (void)setup
{
    // Initialization that can't wait until viewDidLoad
}

- (void)viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:YES];
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)updateUI
{
    //  Save a mutable copy of the Game Results array
    [self.sortResultsArray addObjectsFromArray:[GameResults allGameResults]];
    
    //  Format and Display Game Results
    [self formatGameResutls]; 
}

- (IBAction)sortButtonPressed:(UIButton *)sender
{
    switch (sender.tag) {
        case 1:
            [self createDescriptor:@"end"];
            break;
        case 2:
            [self createDescriptor:@"score"];
            break;
        case 3:
            [self createDescriptor:@"duration"];
            break;
        case 4:
            [self createDescriptor:@"gamePlayed"];
            break;
        default:
            break;
    }
    [self formatGameResutls];
}

- (void)createDescriptor:(NSString *)key
{
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:NO];
    NSArray *sortDescriptors = @[descriptor];
    [self.sortResultsArray sortUsingDescriptors:sortDescriptors];
}

- (void)formatGameResutls
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    NSString *displayText = @"";
    for (GameResults *result in self.sortResultsArray) {
        displayText = [displayText
                       stringByAppendingFormat:@"%@ Score: %d, (%@, %0g)\n", result.gamePlayed, result.score,
                       [dateFormatter stringFromDate:result.end], round(result.duration)];
    }
    
    self.display.text = displayText;
}

@end
