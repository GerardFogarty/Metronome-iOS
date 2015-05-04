//
//  MAppDelegate.h
//  Metronome
//
//  Created by Ger on 02/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"

@class MViewController;

@interface MAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MViewController * viewController;

@property (strong, nonatomic, readonly) PdAudioController *audioController;

@end
