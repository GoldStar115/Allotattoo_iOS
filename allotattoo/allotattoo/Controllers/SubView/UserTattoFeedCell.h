//
//  UserTattoFeedCell.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTattoFeedCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *viewHeader;

@property (weak, nonatomic) IBOutlet UIImageView *imgCommitList;

@property (weak, nonatomic) IBOutlet UIButton *btnCommitList;
@property (weak, nonatomic) IBOutlet UIImageView *imgTatto;
@property (weak, nonatomic) IBOutlet UIImageView *imgListPost;
@property (weak, nonatomic) IBOutlet UIButton *btnLikePost;
@property (weak, nonatomic) IBOutlet UILabel *lblUserCommitNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblUserLikeNumber;

@end
