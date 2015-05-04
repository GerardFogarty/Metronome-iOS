//
//  MModel.m
//  Metronome
//
//  Created by Ger on 02/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>   // for CACurrentMediaTime()

#import "MModel.h"

@implementation MModel

-(MModel*) init
{
    _previousTime = _currentTime = _dt = 0.0;
    _timeOffset = CACurrentMediaTime();      // subtracted from CACurrentMediaTime() in mainLoop, like 'setting the clock at 0' when the program starts
    
    _currentSound = [NSString stringWithFormat:@"tone"];
    _midiNote = 60;
    
    _bpm = 100;
    _minBpm = 30;
    _maxBpm = 250;
    _beatsPerMeasure = 4;
    _beatsThisMeasure = 0;
    
    _notes = [[NSMutableArray alloc] initWithCapacity:12];
    [_notes addObject:@"A"];
    [_notes addObject:@"A#"];
    [_notes addObject:@"B"];
    [_notes addObject:@"C"];
    [_notes addObject:@"C#"];
    [_notes addObject:@"D"];
    [_notes addObject:@"D#"];
    [_notes addObject:@"E"];
    [_notes addObject:@"F"];
    [_notes addObject:@"F#"];
    [_notes addObject:@"G"];
    [_notes addObject:@"G#"];
    
    _midiNote = 60; // middle C MIDI value
    
    return self;
}


// initialise NSTimer to repeatedly call loop
- (void) startLoop
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01f
                                              target:self
                                            selector:@selector(loop)
                                            userInfo:nil
                                             repeats:YES];
}


// Process timing and tell viewcontroller to click when needed
- (void) loop
{
    _previousTime = _currentTime;
    _currentTime = CACurrentMediaTime() - _timeOffset;
    _dt = _currentTime-_previousTime;
    
    if (_metronomeActivated) {
        _timeToNextClick -= _dt;
        
        if (_timeToNextClick < 0.0) {
            [_viewController playClick];
            _timeToNextClick = 60.0/_bpm;
        
            [_viewController rotateNeedleClockwise:_isNeedleClockwise inSeconds:_timeToNextClick];
            _isNeedleClockwise = !_isNeedleClockwise;
        }
    }
    
}


@end
