//
//  MViewController.h
//  Metronome
//
//  Created by Ger on 02/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PdDispatcher.h"

#import "MModel.h"

@class MModel;

@interface MViewController : UIViewController <PdListener> {
    PdDispatcher *dispatcher;
    void *patch;
}

@property (strong, retain) MModel *model;

@property (weak, nonatomic) IBOutlet UILabel *bpmText;
@property (weak, nonatomic) IBOutlet UISlider *bpmSlider;
@property (weak, nonatomic) IBOutlet UIImageView *needleImg;

-(IBAction) toggleMetronome: (id)sender;

// called from model
- (void) playClick;
- (void) rotateNeedleClockwise:(BOOL) clockwise inSeconds:(float) seconds;


@end
