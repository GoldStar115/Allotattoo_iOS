//
//  OtherUserProfileHeader.h
//  allotattoo
//
//  Created by My Star on 8/17/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherUserProfileHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imgOtherUserProfileBack;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUserLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUserPostCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUserFollowCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUserCommentCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblOtherUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherUserChat;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherUserBack;
@property (weak, nonatomic) IBOutlet UIButton *btnOtherUserFollow;
@property (weak, nonatomic) IBOutlet UIImageView *imgOtherUserPIC;

@end
