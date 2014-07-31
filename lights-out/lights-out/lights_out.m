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
    // Set the default values for the combo boxes
    [_darkPeriod selectItemAtIndex:0];
    [_lightPeriod selectItemAtIndex:1];
    
    // Check that we've set a default value for the times
    [self checkTimeSet];
    
    // Check the time once then start a timer for every minute
    [self checkTime];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(checkTime)
                                   userInfo:nil
                                    repeats:YES];
}

- (IBAction)toggle:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"interfaceStyle"]) {
        [defaults setObject:@"light" forKey:@"interfaceStyle"];
    } else if ([[defaults objectForKey:@"interfaceStyle"]  isEqual: @"light"]) {
        [self setThemeToDark];
    } else if ([[defaults objectForKey:@"interfaceStyle"]  isEqual: @"dark"]) {
        [self setThemeToLight];
    }
}

- (IBAction)saveSettings:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *darkTime = [NSString stringWithFormat:@"%@:%@%@", [_darkHour stringValue], [_darkMinute stringValue], [_darkPeriod stringValue]];
    NSString *lightTime = [NSString stringWithFormat:@"%@:%@%@", [_lightHour stringValue], [_lightMinute stringValue], [_lightPeriod stringValue]];
    
    [defaults setObject:darkTime forKey:@"darkTime"];
    [defaults setObject:lightTime forKey:@"lightTime"];
    
    NSInteger dh = [_darkHour intValue];
    if ([_darkPeriod.stringValue isEqualToString:@"PM"]) {
        dh = [_darkHour intValue] + 12;
    }
    
    NSInteger lh = [_lightHour intValue];
    if ([_lightPeriod.stringValue isEqualToString:@"PM"]) {
        lh = [_lightHour intValue] + 12;
    }
    
    [defaults setObject:[NSString stringWithFormat:@"%ld", (long)dh] forKey:@"darkHour"];
    [defaults setObject:[NSString stringWithFormat:@"%ld", (long)lh] forKey:@"lightHour"];
}

- (void) checkTime {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    count++;
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
//    NSInteger currentMinute = [components minute];
    
    
    NSInteger lightHour = [[defaults objectForKey:@"lightHour"] integerValue];
//    NSInteger lightMinute = [[defaults objectForKey:@"lightMinute"] integerValue];
    
    NSInteger darkHour = [[defaults objectForKey:@"darkHour"] integerValue];
//    NSInteger darkMinute = [[defaults objectForKey:@"darkMinute"] integerValue];

    [_debugLabel setStringValue:[NSString stringWithFormat:@"CH: %ld, LH: %@, DH: %@", (long)currentHour, [defaults objectForKey:@"lightHour"], [defaults objectForKey:@"darkHour"]]];
    
    
    if (currentHour >= lightHour && currentHour <= darkHour) {
        [self setThemeToLight];
    } else {
        [self setThemeToDark];
    }
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

- (void) setThemeToDark {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", @"Dark", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
    [defaults setObject:@"dark" forKey:@"interfaceStyle"];
}

- (void) setThemeToLight {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", NULL, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
    [defaults setObject:@"light" forKey:@"interfaceStyle"];
}

@end
