//
//  Emoji.m
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import "Emoji.h"

@implementation Emoji

- (instancetype)initWithEmoji:(NSString *)emoji code:(NSString *)code caption:(NSString *)caption color:(CGColorRef)color {
    self = [super init];
    
    self.emoji = emoji;
    self.code = code;
    self.caption = caption;
    self.color = color;
    
    return self;
}

@end
