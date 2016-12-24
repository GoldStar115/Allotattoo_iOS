//
//  MesFavorisCell.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MesFavorisCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgMesFavoris;
@property (weak, nonatomic) IBOutlet UIView *viewAction;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UIImageView *imgLike;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnVisitUserProfile;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;

@end
