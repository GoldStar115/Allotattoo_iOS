//
//  UserProfileHeaderView.h
//  allotattoo
//
//  Created by My Star on 8/17/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *imgBadge;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblUserLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UIButton *btnProfileSetting;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowerCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblPostCnt;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfileBack;

@end
