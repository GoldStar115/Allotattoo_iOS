//
//  CustomInspirationCell.h
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomInspirationCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *imgLikePost;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnLikePost;
@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIView *viewCellFooter;
@property (weak, nonatomic) IBOutlet UIImageView *imgTattoo;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
