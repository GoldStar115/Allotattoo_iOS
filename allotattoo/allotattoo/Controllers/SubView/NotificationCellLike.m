//
//  NotificationCellLike.m
//  allotattoo
//
//  Created by My Star on 8/8/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "NotificationCellLike.h"

@implementation NotificationCellLike
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource,UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionLikeImage.dataSource = dataSourceDelegate;
    self.collectionLikeImage.delegate = dataSourceDelegate;
    self.collectionLikeImage.indexPath = indexPath;
    
    [self.collectionLikeImage setContentOffset:self.collectionLikeImage.contentOffset animated:NO];
    [self.collectionLikeImage reloadData];
}
@end
