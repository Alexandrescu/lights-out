//
//  lights_out.h
//  lights-out
//
//  Created by Samuel Turner on 31/07/2014.
//  Copyright (c) 2014 Samuel Turner. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>

@interface lights_out : NSPreferencePane
@property (weak) IBOutlet NSTextField *debugLabel;

@property (weak) IBOutlet NSTextField *darkHour;
@property (weak) IBOutlet NSTextField *darkMinute;
@property (weak) IBOutlet NSComboBox *darkPeriod;

@property (weak) IBOutlet NSTextField *lightHour;
@property (weak) IBOutlet NSTextField *lightMinute;
@property (weak) IBOutlet NSComboBox *lightPeriod;

- (void)mainViewDidLoad;

- (IBAction)toggle:(id)sender;
- (IBAction)saveSettings:(id)sender;


@end
