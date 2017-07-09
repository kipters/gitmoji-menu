//
//  EmojiViewController.m
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import "EmojiViewController.h"
#import "NSCollectionViewTableLayout.h"
#import "Emoji.h"
#import "EmojiItem.h"
#import "HeaderView.h"
#import "FooterView.h"

@interface EmojiViewController ()
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSTextField *errorLabel;
@property (weak) IBOutlet NSScrollView *scrollView;

@property (strong, nonatomic) NSArray<__kindof Emoji *> *emojis;

@end

@implementation EmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [NSBundle.mainBundle pathForResource:@"def" ofType:@"json"];
    NSData *def = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    
    id obj = [NSJSONSerialization JSONObjectWithData:def options:0 error:nil];
    
    if (![obj isKindOfClass:NSArray.class]) {
        self.errorLabel.stringValue = @"Could not parse emoji list 😞";
        self.errorLabel.hidden = NO;
        self.scrollView.hidden = YES;
        return;
    }
    
    NSArray *emojiDefinitions = obj;
    NSMutableArray *emojis = [NSMutableArray array];
    
    for (NSDictionary *d in emojiDefinitions) {
        NSString *emoji = [d valueForKey:@"Emoji"];
        NSString *code = [d valueForKey:@"Code"];
        NSString *description = [d valueForKey:@"Description"];
        NSArray *colorArray = [d valueForKey:@"Color"];
        
        CGFloat red = ((NSNumber *)[colorArray objectAtIndex:0]).longValue / 255.0;
        CGFloat green = ((NSNumber *)[colorArray objectAtIndex:1]).longValue / 255.0;
        CGFloat blue = ((NSNumber *)[colorArray objectAtIndex:2]).longValue / 255.0;
        
        CGColorRef color = CGColorCreateGenericRGB(red, green, blue, 1.0);
        
        Emoji *e = [[Emoji alloc] initWithEmoji:emoji code:code caption:description color:color];
        [emojis addObject:e];
    }
    
    self.emojis = [NSArray arrayWithArray:emojis];
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0) {
        HeaderView *header = [collectionView makeItemWithIdentifier:@"HeaderView" forIndexPath:indexPath];
        header.view.wantsLayer = YES;
        header.view.layer.backgroundColor = CGColorCreateGenericRGB(1, 0xDD/255.0, 0x67/255.0, 1.0);
        return header;
    }
    
    if (indexPath.item >= self.emojis.count + 1) {
        FooterView *footer = [collectionView makeItemWithIdentifier:@"FooterView" forIndexPath:indexPath];
        return footer;
    }
    
    EmojiItem *item = [collectionView makeItemWithIdentifier:@"EmojiItem" forIndexPath:indexPath];
    
    // accounting for the header fake item
    Emoji *emoji = [self.emojis objectAtIndex:indexPath.item - 1];
    
    [item setColor:emoji.color];
    [item setEmoji:emoji.emoji];
    [item setCode:emoji.code];
    [item setCaption:emoji.caption];
    
    return item;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    if (indexPaths.count == 0) {
        return;
    }
    
    NSIndexPath* emojiPath = indexPaths.anyObject;
    // accounting for the header fake item
    long index = emojiPath.item;
    
    if (index == 0) {
        // no action
    } else if (index == self.emojis.count + 1) {
        [NSWorkspace.sharedWorkspace openURL:[NSURL URLWithString:@"https://carloscuesta.me"]];
        [self animateClickHintFor:collectionView at:emojiPath];
    } else {
    
        Emoji *emoji = [self.emojis objectAtIndex:index - 1];
        NSString *code = emoji.code;
    
        NSPasteboard *pb = NSPasteboard.generalPasteboard;
        [pb clearContents];
        [pb writeObjects:@[code]];
        
        [self animateClickHintFor:collectionView at:emojiPath];
    }
    
    [collectionView deselectItemsAtIndexPaths:indexPaths];
}

-(void)animateClickHintFor:(NSCollectionView *)collectionView at:(NSIndexPath *)indexPath {
    NSCollectionViewItem *item = [collectionView itemAtIndexPath:indexPath];
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
        context.duration = 0.10;
        item.view.animator.alphaValue = 0.2;
    } completionHandler:^{
        [NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
            context.duration = 0.25;
            item.view.animator.alphaValue = 1;
        } completionHandler:nil];
    }];

}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // adding 3 fake items to account for my lack of ability in making the supplementary views work and some bug
    // that for some reason doesn't show the last item in the collection
    return self.emojis.count + 3;
}

@end
