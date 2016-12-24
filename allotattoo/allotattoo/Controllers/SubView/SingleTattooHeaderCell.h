//
//  SingleTattooHeaderCell.h
//  allotattoo
//
//  Created by My Star on 8/24/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTattooHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewUserContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgArtistPic;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistName;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistCommitTime;



@property (weak, nonatomic) IBOutlet UIView *viewSinglePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgSinglePhoto;


@property (weak, nonatomic) IBOutlet UIView *viewMainAction;
@property (weak, nonatomic) IBOutlet UIImageView *imgCommit;
@property (weak, nonatomic) IBOutlet UILabel *lblCommitNumber;

@property (weak, nonatomic) IBOutlet UIImageView *imgLike;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *lblLikeNumber;

@property (weak, nonatomic) IBOutlet UIImageView *imgShare;


@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnTattoistProfile;

@property (weak, nonatomic) IBOutlet UIButton *btnCommit;
@end
