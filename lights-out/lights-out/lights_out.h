//
//  lights_out.h
//  lights-out
//
//  Created by Samuel Turner on 31/07/2014.
//  Copyright (c) 2014 Samuel Turner. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import "FFYDaemonController.h"

@interface lights_out : NSPreferencePane

@property (strong, nonatomic) FFYDaemonController *daemonController;

@property (weak) IBOutlet NSTextField *debugLabel;
@property (weak) IBOutlet NSTextField *darkHour;
@property (weak) IBOutlet NSTextField *lightHour;
@property (weak) IBOutlet NSButton *toggleButton;
@property (weak) IBOutlet NSTextField *status;

- (void)mainViewDidLoad;
- (void) saveInformation;

- (IBAction)toggle:(id)sender;


@end
