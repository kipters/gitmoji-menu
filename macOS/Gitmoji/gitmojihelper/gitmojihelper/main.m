//
//  main.m
//  gitmojihelper
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "AppDelegate.h"

int main(int argc, const char * argv[]) {
    AppDelegate *delegate = [[AppDelegate alloc] init];
    NSApplication.sharedApplication.delegate = delegate;
    return NSApplicationMain(argc, argv);
}
