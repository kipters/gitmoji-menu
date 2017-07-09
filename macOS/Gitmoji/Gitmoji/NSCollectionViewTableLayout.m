//
//  NSCollectionViewTableLayout.m
//  Gitmoji
//
//  Created by Fabio Di Peri on 09/07/2017.
//  Copyright © 2017 Fabio Di Peri. All rights reserved.
//

#import "NSCollectionViewTableLayout.h"

CGFloat const itemHeight = 65;
CGFloat const verticalSpacing = 2;
CGFloat const headerHeight = 120;
CGFloat const footerHeight = 65;

@implementation NSCollectionViewTableLayout

- (NSSize)collectionViewContentSize {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    if (count == 0) {
        return NSZeroSize;
    }
    
    NSSize size = self.collectionView.superview.bounds.size;
    count -= 3;
    size.height = ((CGFloat)count * (itemHeight + verticalSpacing)) - 3 * verticalSpacing + headerHeight + footerHeight;
    return size;
}

- (NSCollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    if (count == 0) {
        return nil;
    }
    
    int height = itemHeight;
    int offset = headerHeight - itemHeight - verticalSpacing;
    if (indexPath.item == 0) {
        height = headerHeight;
        offset = 0;
    }
    
    if (indexPath.item == [self.collectionView numberOfItemsInSection:0] - 1) {
        height = footerHeight;
    }
    
    NSRect frame = NSMakeRect(0,
                              ((itemHeight + verticalSpacing) * (CGFloat)(indexPath.item)) + offset,
                              self.collectionViewContentSize.width,
                              height);
    
    NSCollectionViewLayoutAttributes *itemAttributes = [NSCollectionViewLayoutAttributes layoutAttributesForItemWithIndexPath:indexPath];
    itemAttributes.frame = frame;
    
    return itemAttributes;
}

- (NSArray<__kindof NSCollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(NSRect)rect {
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    for (int i = 0; i < count - 1; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        NSCollectionViewLayoutAttributes *itemAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        if (itemAttributes != nil) {
            [attributes addObject:itemAttributes];
        }
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(NSRect)newBounds {
    return YES;
}

@end
