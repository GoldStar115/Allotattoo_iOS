//
//  ArtistProfileHeaderView.h
//  allotattoo
//
//  Created by My Star on 8/17/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistProfileHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *lblPostCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowerCnt;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentCnt;
@property (weak, nonatomic) IBOutlet UIImageView *imgBadge;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistName;
@property (weak, nonatomic) IBOutlet UIButton *btnProfileSetting;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;

@end
