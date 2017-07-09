//
//  EmojiItem.m
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import "EmojiItem.h"

@interface EmojiItem ()
@property (weak) IBOutlet NSBox *emojiBox;
@property (weak) IBOutlet NSTextField *emojiLabel;
@property (weak) IBOutlet NSTextField *codeLabel;
@property (weak) IBOutlet NSTextField *captionLabel;
@property (weak) IBOutlet NSBox *tintBox;

@property (strong, nonatomic) NSColor *highlightColor;
@property (strong, nonatomic) NSColor *baseColor;

@end

@implementation EmojiItem

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:self.view.bounds
                                                                options:NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways
                                                                  owner:self
                                                               userInfo:nil];
    
    [self.view addTrackingArea:trackingArea];
}

- (void)mouseEntered:(NSEvent *)event {
    self.emojiBox.fillColor = self.highlightColor;
}

- (void)mouseExited:(NSEvent *)event {
    self.emojiBox.fillColor = self.baseColor;
}

- (void)setEmoji:(NSString *)emoji {
    self.emojiLabel.stringValue = emoji;
}

- (void)setColor:(CGColorRef)color {
    NSColor *c = [NSColor colorWithCGColor:color];
    NSColor *hc = [NSColor colorWithCGColor:CGColorCreateGenericRGB(c.redComponent, c.greenComponent, c.blueComponent, .4)];
    self.highlightColor = hc;
    self.baseColor = c;
    self.emojiBox.fillColor = c;
}

- (void)setCode:(NSString *)code {
    self.codeLabel.stringValue = code;
}

- (void)setCaption:(NSString *)caption {
    self.captionLabel.stringValue = caption;
}

@end
