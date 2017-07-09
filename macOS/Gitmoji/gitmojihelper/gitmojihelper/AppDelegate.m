//
//  AppDelegate.m
//  gitmojihelper
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    BOOL alreadyRunning = NO;
    NSArray *running = NSWorkspace.sharedWorkspace.runningApplications;
    for (NSRunningApplication *app in running) {
        if ([app.bundleIdentifier isEqualToString:@"com.kipters.gitmoji"]) {
            alreadyRunning = YES;
            break;
        }
    }
    
    if (!alreadyRunning) {
        NSString *path = NSBundle.mainBundle.bundlePath;
        NSArray *p = path.pathComponents;
        NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:p];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents removeLastObject];
        [pathComponents addObject:@"MacOS"];
        [pathComponents addObject:@"Gitmoji"];
        NSString *newPath = [NSString pathWithComponents:pathComponents];
        NSLog(@"%@", newPath);
        [[NSWorkspace sharedWorkspace] launchApplication:newPath];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
