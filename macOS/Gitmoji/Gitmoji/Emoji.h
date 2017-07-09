//
//  Emoji.h
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Emoji : NSObject

@property (strong, nonatomic) NSString *emoji;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *caption;
@property (assign, nonatomic) CGColorRef color;

- (instancetype)initWithEmoji:(NSString *)emoji code:(NSString *)code caption:(NSString *)caption color:(CGColorRef)color;

@end
