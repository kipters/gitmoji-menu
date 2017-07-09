//
//  HeaderView.m
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
@property (weak) IBOutlet NSTextField *githubLabel;
@property (weak) IBOutlet NSButton *githubButton;

@property (strong, nonatomic) NSClickGestureRecognizer *clickRecognizer;

@end

@implementation HeaderView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    NSClickGestureRecognizer *clickRecognizer = [[NSClickGestureRecognizer alloc] initWithTarget:self action:@selector(onGithubLabelClick)];
    [self.githubLabel addGestureRecognizer:clickRecognizer];
    self.clickRecognizer = clickRecognizer;
    
    NSTrackingArea *githubTrackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds
                                                                      options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                                        owner:self
                                                                     userInfo:nil];
    
    [self.view addTrackingArea:githubTrackingArea];
    self.githubLabel.alphaValue = 0;
}

- (void)mouseEntered:(NSEvent *)event {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = .3;
        self.githubLabel.animator.alphaValue = 1.0;
    } completionHandler:nil];
}

- (void)mouseExited:(NSEvent *)event {
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = .3;
        self.githubLabel.animator.alphaValue = 0;
    } completionHandler:nil];
}

- (IBAction)onGithubButtonClick:(id)sender {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://github.com/kipters/gitmoji-menu"]];
}

- (void)onGithubLabelClick {
    [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://github.com/kipters/gitmoji-menu"]];
}

@end
