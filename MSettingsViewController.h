//
//  MSettingsViewController.h
//  Metronome
//
//  Created by Ger on 12/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MModel.h"


@interface MSettingsViewController : UIViewController

@property (strong, retain) MModel *model;

@property (weak, nonatomic) IBOutlet UISwitch *clickSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *flashSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *vibSwitch;
@property (weak, nonatomic) IBOutlet UIButton *decrementBtn;
@property (weak, nonatomic) IBOutlet UIButton *incrementBtn;
@property (weak, nonatomic) IBOutlet UILabel *toneLabel;

- (IBAction)done:(id)sender;

@end
