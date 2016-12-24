//
//  NotificationCell.h
//  allotattoo
//
//  Created by My Star on 7/11/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InsideCollectionView.h"
@interface NotificationCellFollow : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgClock;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@end
