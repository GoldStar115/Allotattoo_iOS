//
//  NotificationCellLike.h
//  allotattoo
//
//  Created by My Star on 8/8/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsideCollectionView.h"

@interface NotificationCellLike : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPicFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblUserNameFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblStatusFollow;
@property (weak, nonatomic) IBOutlet InsideCollectionView *collectionLikeImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgClockFollow;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeFollow;
- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource,UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
@end
