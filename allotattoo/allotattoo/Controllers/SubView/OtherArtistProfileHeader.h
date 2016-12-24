//
//  OtherArtistProfileHeader.h
//  allotattoo
//
//  Created by My Star on 8/17/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherArtistProfileHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *lblOtherArtistName;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherArtistLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherArtistPostCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherArtistFollowCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherArtistCommentCnt;
@property (weak, nonatomic) IBOutlet UIButton *btnChatWithOtherArtist;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowOtherArtist;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgOtherArtistPic;

@end
