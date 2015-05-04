//
//  MModel.h
//  Metronome
//
//  Created by Ger on 02/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MViewController.h"

@class MViewController;

@interface MModel : NSObject

@property (strong, retain) MViewController* viewController;

@property (assign) int bpm;                         // beats per minute.
@property (assign) int minBpm;
@property (assign) int maxBpm;

@property (assign) int beatsPerMeasure;             
@property (assign) int beatsThisMeasure;

@property (assign) BOOL isNeedleClockwise;          // can be moving clockwise or anti-clockwise
@property (assign) BOOL metronomeActivated;

// is sound, vibrate and flash turned on/off?
@property (assign) BOOL sound;
@property (assign) BOOL vibrate;
@property (assign) BOOL flash;

@property (strong, retain) NSString *currentSound;  // name of receiver in PD patch for the current chosen sound
@property (assign) int midiNote;                    // note to be played (if currentSound == "midi")
@property (strong, retain) NSMutableArray* notes;   // array holding string representation of possible midi notes (A-G including sharps)

// timing information
@property (assign) float timeToNextClick;       // click played every 60/bpm seconds
@property (assign) float previousTime;          // time at last cycle
@property (assign) float currentTime;           // time now
@property (assign) float dt;                    // how much time has passed since last cycle (previousTime - currentTime)
@property (assign) float timeOffset;            // subtracted from CACurrentMediaTime() in mainLoop to get actual time
@property (strong, retain) NSTimer *timer;

- (void) startLoop;
- (void) loop;

@end