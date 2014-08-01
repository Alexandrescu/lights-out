//
//  main.m
//  lights-out-daemon
//
//  Created by Samuel Turner on 1/08/2014.
//  Copyright (c) 2014 Samuel Turner. All rights reserved.
//

#import <Foundation/Foundation.h>

void setThemeToDark();
void setThemeToLight();
void checkTime();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSString *lightHour = [NSString stringWithFormat:@"%s", argv[1]];
        NSString *darkHour = [NSString stringWithFormat:@"%s", argv[2]];
        while(1) {
            checkTime(lightHour, darkHour);
            sleep(1);
        }
    }
    return 0;
}

void checkTime(NSString *lightHour, NSString *darkHour) {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
    
    int lightInt = [lightHour intValue];
    int darkInt = [darkHour intValue];
    
    if (currentHour >= lightInt && currentHour < darkInt) {
        setThemeToLight();
    } else {
        setThemeToDark();
    }
}

void setThemeToDark() {
    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", @"Dark", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
}

void setThemeToLight() {
    CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", NULL, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
}