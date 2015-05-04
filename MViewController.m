//
//  MViewController.m
//  Metronome
//
//  Created by Ger on 02/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#import "MSettingsViewController.h"
#import "MViewController.h"

@interface MViewController ()

@end

@implementation MViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]]];
    
    // create dispatcher to communicate between this program and the PD patch
    dispatcher = [PdDispatcher new];
    [PdBase setDelegate:dispatcher];
    
    // open the patch file
    patch = [PdBase openFile:@"patch.pd"
                        path:[[NSBundle mainBundle] resourcePath]];
    
    if (!patch) {
        NSLog(@"patch didnt open");
    }
    
    _model = [[MModel alloc] init];
    [_model setViewController:self];
    
    
    _model.sound = YES;
    _model.flash = NO;
    _model.vibrate = NO;
    
    
    /*
    [_noteStepper setValue: _model.midiNote-57]; // midinote ranges from 57-69, subtract 57 to get stepper-appropriate value
    */
    
    
    [self.view bringSubviewToFront:_needleImg];
    _needleImg.layer.anchorPoint = CGPointMake(0.48, 1.0);
    [self rotateNeedleClockwise:YES inSeconds:0.01f];

}


// send message to patch to trigger a click sound or midi tone depending on user's setting
-(void) playClick
{
    
    if ( [[_model currentSound] isEqualToString:@"tone"]) {
        
        // send the chosen midi note to the patch
        int midiNote = [_model midiNote];
        [PdBase sendFloat:midiNote toReceiver:@"midinote"];
    }
    
    // calculate if this beat is an off-beat (different sound like tick-tick-tick-tock etc)
    // this is no longer implemented
    _model.beatsThisMeasure++;
    if (_model.beatsThisMeasure == _model.beatsPerMeasure) {
        _model.beatsThisMeasure = 0;
        // change message sent to patch to modify sound into 'offbeat' sound
    }
    
    
    
    // Play sound, vibrate and flash depending on settings by user
    if (_model.sound == YES) {
        [PdBase sendBangToReceiver: [_model currentSound]];
    }
    if (_model.vibrate == YES) {
        [self startVibrate];
    }
    if (_model.flash == YES) {
        [self flashTorch];
    }
}


// Fire needle rotation animation with given direction and duration in seconds
-(void) rotateNeedleClockwise:(BOOL) clockwise inSeconds:(float) seconds
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:NO];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:0];
    [UIView setAnimationDuration:seconds];
    
    float angle = clockwise? 0.25 : -0.25;
    _needleImg.transform = CGAffineTransformMakeRotation(M_PI*angle);
    [UIView commitAnimations];
}


// tell model to start counting
-(IBAction) toggleMetronome:(id)sender
{
    [_model setMetronomeActivated: ![_model metronomeActivated]];
    
    if ( [_model metronomeActivated] ) {
        [_model startLoop];
    }
}


// Flash the torch for an instant
-(void) flashTorch
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    /*
     // this gets tripped right away in the simulator as theres no torch
     if ([device hasTorch] == NO) {
        NSLog(@"no torch");
        return;
     }*/
    
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOn];
    [device unlockForConfiguration];
    
    NSLog(@"torch on");
    
    [self performSelector:@selector(disableTorch:) withObject:nil afterDelay:0.001];
}

-(void) disableTorch:(id)obj
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [device lockForConfiguration:nil];
    [device setTorchMode:AVCaptureTorchModeOff];
    [device unlockForConfiguration];
    NSLog(@"torch off");
}


// Vibrate for an instant
-(void) startVibrate
{
    AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, nil);
    NSLog(@"vibrate on");
    [self performSelector:@selector(stopVibrate:) withObject:nil afterDelay:0.001];
}

-(void) stopVibrate:(id)obj
{
    AudioServicesStopSystemSound(kSystemSoundID_Vibrate);
    
    NSLog(@"vibrate off");
}


// Value changed in UIStepper or UISlider
-(IBAction) valueChanged: (id)sender
{
    if ([sender isKindOfClass:[UIStepper class]]) {
        
        /*UIStepper* stepper = (UIStepper*) sender;
        
        // user pressed note stepper
        if (stepper.tag == 2) {
            int newNoteValue = stepper.value;  
            
            [_model setMidiNote:newNoteValue+57]; // 57 == midi value for middle A
            NSString* newNoteString = [_model.notes objectAtIndex: _model.midiNote-57];
            [_noteLabel setText:newNoteString];
        }*/
    }
    
    else if ([sender isKindOfClass:[UISlider class]]) {
        
        UISlider* slider = (UISlider*) sender;
        [_model setBpm: (int) slider.value];
        [_bpmText setText: [NSString stringWithFormat:@"%d", _model.bpm]];
    }
}

// Give destination a pointer to the Model
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MSettingsViewController *vc = segue.destinationViewController;
    vc.model = _model;
}

@end
