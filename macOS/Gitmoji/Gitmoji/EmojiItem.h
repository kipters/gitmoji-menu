//
//  EmojiItem.h
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface EmojiItem : NSCollectionViewItem
- (void)setEmoji:(NSString *)emoji;
- (void)setColor:(CGColorRef)color;
- (void)setCode:(NSString *)code;
- (void)setCaption:(NSString *)caption;
@end
