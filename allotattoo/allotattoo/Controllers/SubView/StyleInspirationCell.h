//
//  StyleInspirationCell.h
//  AllTattoo
//
//  Created by My Star on 7/2/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleInspirationCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgStyleFeed;
@property (weak, nonatomic) IBOutlet UIView *viewFooter;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfilePhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgPostLike;
@property (weak, nonatomic) IBOutlet UILabel *lblProfileName;
@property (weak, nonatomic) IBOutlet UIButton *btnPostLike;
@property (weak, nonatomic) IBOutlet UIButton *btnProfileVisite;

@end
