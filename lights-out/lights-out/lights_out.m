//
//  lights_out.m
//  lights-out
//
//  Created by Samuel Turner on 31/07/2014.
//  Copyright (c) 2014 Samuel Turner. All rights reserved.
//

#import "lights_out.h"

@implementation lights_out

int count = 0;

- (void)mainViewDidLoad
{
    // Instantiate the daemon controller and set the launch path
    _daemonController = [[FFYDaemonController alloc]init];
    _daemonController.launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"lights-out-daemon" ofType:@""];
    
    // Check that we've set a default value for the times
    [self checkTimeSet];
    [self checkDaemonStatus];
    [self updateLabels];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _daemonController.startArguments = [NSArray arrayWithObjects:
                                       [defaults objectForKey:@"lightHour"],
                                       [defaults objectForKey:@"darkHour"],
                                        nil];
}

- (void) updateLabels {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int darkHour = [[defaults objectForKey:@"darkHour"] intValue];
    darkHour = darkHour -12;
    
    [_darkHour setStringValue:[NSString stringWithFormat:@"%d", darkHour]];
    [_lightHour setStringValue:[defaults objectForKey:@"lightHour"]];
    
    if (![_daemonController running]) {
        _darkHour.enabled = YES;
        _lightHour.enabled = YES;
        [_toggleButton setTitle:@"Start Service"];
        [_debugLabel setStringValue:[NSString stringWithFormat:@"Service is not running"]];
        [_debugLabel setTextColor:[NSColor colorWithCalibratedRed:0.88 green:0.3 blue:0.26 alpha:1.0]];
    } else if ([_daemonController running]) {
        _darkHour.enabled = NO;
        _lightHour.enabled = NO;
        [_toggleButton setTitle:@"Stop Service"];
        [_debugLabel setStringValue:[NSString stringWithFormat:@"Service is running"]];
        [_debugLabel setTextColor:[NSColor colorWithCalibratedRed:0.28 green:0.79 blue:0.47 alpha:1.0]];
    }
}


- (NSString *) checkDaemonStatus {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"daemonStatus"]) {
        [defaults setObject:@"running" forKey:@"daemonStatus"];
        [_daemonController start];
    }
    
    return [defaults objectForKey:@"daemonStatus"];
}

- (void) setDaemonStatus: (NSString *)status {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:status forKey:@"daemonStatus"];
}

- (IBAction)toggle:(id)sender {    
    // Toggle the daemon
    if ([[self checkDaemonStatus] isEqualToString:@"stopped"]) {
        [self saveInformation];
        [_daemonController start];
        [self setDaemonStatus:@"running"];
    } else if ([[self checkDaemonStatus] isEqualToString:@"running"]) {
        [_daemonController stop];
        [self setDaemonStatus:@"stopped"];
    }
    
    [self updateLabels];
}

- (void) saveInformation {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger dh = [_darkHour intValue];
    dh = [_darkHour intValue] + 12;
    
    
    NSInteger lh = [_lightHour intValue];
    lh = [_lightHour intValue];
    
    
    [defaults setObject:[NSString stringWithFormat:@"%ld", (long)dh] forKey:@"darkHour"];
    [defaults setObject:[NSString stringWithFormat:@"%ld", (long)lh] forKey:@"lightHour"];
    
    _daemonController.startArguments = [NSArray arrayWithObjects:
                                        [defaults objectForKey:@"lightHour"],
                                        [defaults objectForKey:@"darkHour"],
                                        nil];
    
    // Restart if the arguments change
    [self updateLabels];
}

- (void) checkTimeSet {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (![defaults objectForKey:@"darkTime"]) {
        [defaults setObject:@"5:30PM" forKey:@"darkTime"];
        [defaults setObject:@"17" forKey:@"darkHour"];
        [defaults setObject:@"30" forKey:@"darkMinute"];
    } else if (![defaults objectForKey:@"lightTime"]) {
        [defaults setObject:@"7:30AM" forKey:@"lightTime"];
        [defaults setObject:@"7" forKey:@"lightHour"];
        [defaults setObject:@"30" forKey:@"lightMinute"];
    }
}

@end
