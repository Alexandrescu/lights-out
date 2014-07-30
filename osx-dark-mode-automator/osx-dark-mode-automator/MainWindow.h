//
//  MainWindow.h
//  osx-dark-mode-automator
//
//  Created by Samuel Turner on 30/07/2014.
//  Copyright (c) 2014 Samuel Turner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainWindow : NSWindow

- (IBAction)toggle:(id)sender;

@property (weak) IBOutlet NSTextField *toggleText;

@end
