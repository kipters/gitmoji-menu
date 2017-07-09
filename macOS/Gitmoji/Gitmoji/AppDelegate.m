//
//  AppDelegate.m
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import "AppDelegate.h"
#import "EmojiViewController.h"
@import ServiceManagement;

NSString *const RunAtStartupDefaultsKey = @"runAtStartup";

@interface AppDelegate ()

@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSPopover *popover;
@property (strong, nonatomic) NSMenu *menu;
@property (strong, nonatomic) NSMenuItem *startupMenuItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSStatusItem *statusItem = [NSStatusBar.systemStatusBar statusItemWithLength:NSVariableStatusItemLength];
    statusItem.button.image = [NSImage imageNamed:@"BarIcon"];
    statusItem.button.action = @selector(itemClicked:);
    [statusItem.button sendActionOn:NSEventMaskLeftMouseUp | NSEventMaskRightMouseUp];
    
    self.statusItem = statusItem;
    
    NSMenuItem *startupMenuItem = [[NSMenuItem alloc] initWithTitle:@"Run at startup"
                                                             action:@selector(startupRun:)
                                                      keyEquivalent:@""];
    
    NSUserDefaults *settings = NSUserDefaults.standardUserDefaults;
    BOOL runAtStartup = [settings boolForKey:RunAtStartupDefaultsKey];
    
    if (runAtStartup)
        startupMenuItem.state = NSOnState;
    
    NSMenu *menu = [[NSMenu alloc] init];
    [menu addItem:startupMenuItem];
    [menu addItem:NSMenuItem.separatorItem];
    NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@"q"];
    [menu addItem:quitMenuItem];
    
    self.startupMenuItem = startupMenuItem;
    self.menu = menu;
    
    NSPopover *popover = [[NSPopover alloc] init];
    popover.behavior = NSPopoverBehaviorTransient;
    popover.contentViewController = [[EmojiViewController alloc] init];
    
    self.popover = popover;
}

- (void)itemClicked:(id)sender {
    NSEvent *event = NSApp.currentEvent;
    
    if (event.type == NSEventTypeRightMouseUp || event.modifierFlags & NSControlKeyMask) {
        [self.statusItem popUpStatusItemMenu:self.menu];
        return;
    }
    
    if (self.popover.shown) {
        [self hidePopover:sender];
    } else {
        [self showPopover:sender];
    }
}

- (void)startupRun:(id)sender {
    NSMenuItem *menuItem = (NSMenuItem *)sender;
    NSUserDefaults *settings = NSUserDefaults.standardUserDefaults;
    BOOL runAtStartup = [settings boolForKey:RunAtStartupDefaultsKey];
    
    if (runAtStartup) {
        if (!SMLoginItemSetEnabled((__bridge CFStringRef)@"com.kipters.gitmojihelper", NO)) {
            return;
        }
        
        menuItem.state = NSOffState;
        [settings setBool:NO forKey:RunAtStartupDefaultsKey];
    } else {
        if (!SMLoginItemSetEnabled((__bridge CFStringRef)@"com.kipters.gitmojihelper", YES)) {
            return;
        }
        
        menuItem.state = NSOnState;
        [settings setBool:YES forKey:RunAtStartupDefaultsKey];
    }
    
    [settings synchronize];
    
}

- (void)showPopover:(id)sender {
    NSStatusBarButton *button = self.statusItem.button;
    [self.popover showRelativeToRect:button.bounds ofView:button preferredEdge:NSMinYEdge];
}

- (void)hidePopover:(id)sender {
    [self.popover performClose:sender];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
