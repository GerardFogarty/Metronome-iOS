//
//  MSettingsViewController.m
//  Metronome
//
//  Created by Ger on 12/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import <QuartzCore/CALayer.h>

#import "MSettingsViewController.h"

@interface MSettingsViewController ()

@end

@implementation MSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // remove the imageviews and reinsert behind the switches
    for (int i=1; i<=5; i++) {
        UIImageView* img = (UIImageView*) [self.view viewWithTag:i];
        
        [img removeFromSuperview];
        [self.view insertSubview:img atIndex:1];
        
        CALayer *l = [img layer];
        [l setCornerRadius:12.0];
        
        NSString* newNoteString = [_model.notes objectAtIndex: _model.midiNote-57]; // -57 to account for A being midi note 57
        [_toneLabel setText:newNoteString];

    }
}

// Called by Return button
- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// User pressed an option, check the changes they made
-(IBAction) valueChanged: (id)sender
{
    // check switches
    if (_clickSwitch.isOn)
        [_model setCurrentSound:@"tone"];
    else 
        [_model setCurrentSound:@"click"];
    
    [_model setSound: _soundSwitch.isOn];
    [_model setVibrate: _vibSwitch.isOn];
    [_model setFlash: _flashSwitch.isOn];
    
    
    // check buttons
    if ([sender isKindOfClass: [UIButton class]]) {
        UIButton* btn = (UIButton*) sender;
        
        if ([btn isEqual:_decrementBtn] && _model.midiNote>57) {
            _model.midiNote--;
            
            // minimum note 
            if (_model.midiNote == 57)  {
                _decrementBtn.enabled = NO;
                _decrementBtn.alpha = 0.3;
            }
            
            // reenable increment button if it is disabled
            if (_incrementBtn.enabled == NO) {
                _incrementBtn.enabled = YES;
                _incrementBtn.alpha = 1.0;
            }
        }
        else if ([btn isEqual:_incrementBtn] && _model.midiNote<68) {
            _model.midiNote++;
            
            if (_model.midiNote == 68) {
                _incrementBtn.enabled = NO;
                _incrementBtn.alpha = 0.3;
            }
            
            if (_decrementBtn.enabled == NO) {
                _decrementBtn.enabled = YES;
                _decrementBtn.alpha = 1.0;
            }
                
        }
        // update label with new note
        NSString* newNoteString = [_model.notes objectAtIndex: _model.midiNote-57]; // -57 to account for A being midi note 57 but the string "A" is at index 0
        [_toneLabel setText:newNoteString];
        
    }
}

@end
