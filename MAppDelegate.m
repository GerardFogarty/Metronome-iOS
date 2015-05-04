//
//  MAppDelegate.m
//  Metronome
//
//  Created by Ger on 02/12/2013.
//  Copyright (c) 2013 Gerard Fogarty. All rights reserved.
//

#import "MAppDelegate.h"
#import "MViewController.h"

@implementation MAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // initialise PD controller at standard rate 44100
    _audioController = [[PdAudioController alloc] init];
    if ([self.audioController configureAmbientWithSampleRate:44100
                                              numberChannels:2
                                               mixingEnabled:YES]
        != PdAudioOK) {
        NSLog(@"failed to initialize audio components");
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    self.audioController.active = NO;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    self.audioController.active = YES;
}

@end
