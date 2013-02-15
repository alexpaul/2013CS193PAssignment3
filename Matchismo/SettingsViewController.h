//
//  SettingsViewController.h
//  Matchismo
//
//  Created by Alex Paul on 2/12/13.
//  Copyright (c) 2013 Alex Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameViewController.h"

@interface SettingsViewController : CardGameViewController

//  Public for CardGameViewController
@property (weak, nonatomic) IBOutlet UISwitch *gameModeSwitch;

@end
