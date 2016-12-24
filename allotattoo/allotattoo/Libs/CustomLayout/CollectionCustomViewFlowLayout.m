//
//  CollectionViewFlowLayout.m
//  shopcrew
//
//  Created by LoveStar_PC on 6/29/16.
//  Copyright © 2016 Mike. All rights reserved.
//

#import "CollectionCustomViewFlowLayout.h"

@implementation CollectionCustomViewFlowLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
    NSMutableArray * resArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes * attributes in arrayCache) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [resArray addObject:attributes];
        }
    }
    return resArray;
}
- (void) prepareLayout {
    arrayCache = [NSMutableArray array];
    UIEdgeInsets insets = self.collectionView.contentInset;
    contentWidth = CGRectGetWidth(self.collectionView.bounds) - (insets.left + insets.right);
    contentHeight = 0;
    NSInteger expandedFeedback = -1;
    NSInteger cntColumn = 2;
    CGFloat cellPadding_x = 5;
    CGFloat cellPadding_y = 10;
    
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        CGSize cellSize = [self.delegate cellSizeWithCollectionView:self.collectionView forIndexPath:indexPath];
        CGRect cellRect = CGRectMake(cellPadding_x + (i % cntColumn) * self.collectionView.frame.size.width / cntColumn, cellPadding_y, cellSize.width, cellSize.height);
        UICollectionViewLayoutAttributes * attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        if (i < 2) {
            if (i == 1) {
                if (expandedFeedback == 0 || expandedFeedback == 1) {
                    cellRect.origin.x = cellPadding_x;
                    cellRect.origin.y = [arrayCache[0] frame].origin.y + [arrayCache[0] frame].size.height + cellPadding_y;
                }
            }
        } else {
            cellRect = CGRectMake(cellPadding_x + (i % cntColumn) * self.collectionView.frame.size.width / cntColumn, [arrayCache[i - 2] frame].origin.y + [arrayCache[i - 2] frame].size.height + cellPadding_y, cellSize.width, cellSize.height);
            if (expandedFeedback >= 0) {
                if (expandedFeedback + 1 == i) {
                    cellRect = CGRectMake(cellPadding_x, [arrayCache[i - 1] frame].origin.y + [arrayCache[i - 1] frame].size.height + cellPadding_y, cellSize.width, cellSize.height);
                } else if (expandedFeedback == i) {
                    cellRect = CGRectMake(cellPadding_x, [arrayCache[i - 1] frame].origin.y + [arrayCache[i - 1] frame].size.height + cellPadding_y, cellSize.width, cellSize.height);
                } else if (expandedFeedback < i) {
                    cellRect = CGRectMake(cellPadding_x + ((i - expandedFeedback - 1) % cntColumn) * self.collectionView.frame.size.width / cntColumn, [arrayCache[i - 2] frame].origin.y + [arrayCache[i - 2] frame].size.height + cellPadding_y, cellSize.width, cellSize.height);
                }

            }
            
        }
        contentHeight = MAX(contentHeight, CGRectGetMaxY(cellRect));
        attributes.frame = cellRect;
        [arrayCache addObject:attributes];
    }
}
- (CGSize) collectionViewContentSize {
    return CGSizeMake(contentWidth, contentHeight);
}

@end
