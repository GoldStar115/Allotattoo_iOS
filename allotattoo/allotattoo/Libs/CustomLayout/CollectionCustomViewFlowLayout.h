//
//  CollectionViewFlowLayout.h
//  shopcrew
//
//  Created by LoveStar_PC on 6/29/16.
//  Copyright © 2016 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CollectionViewCustomFlowLayoutDelegate
- (CGSize) cellSizeWithCollectionView:(UICollectionView *) collectionView forIndexPath:(NSIndexPath *) indexPath;

@end
@interface CollectionCustomViewFlowLayout : UICollectionViewFlowLayout

{
    NSMutableArray * arrayCache;
    CGFloat contentHeight;
    CGFloat contentWidth;
    
}
@property (weak, nonatomic) id                      delegate;

@end
