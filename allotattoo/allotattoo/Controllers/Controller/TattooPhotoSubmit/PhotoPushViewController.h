//
//  PhotoPushViewController.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "PhotoFeedViewController.h"


@interface PhotoPushViewController : UIViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *txtViewDes;

@property (weak, nonatomic) IBOutlet UIImageView *imgCapturedPhoto;

@property (weak, nonatomic) IBOutlet UILabel *lblSelectTattooStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblTattooBody;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistName;
@property (weak, nonatomic) IBOutlet UILabel *lblTattooShopName;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleChanger;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleOblig;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyChanger;
@property (weak, nonatomic) IBOutlet UILabel *lblBodyObilg;

@property NSString *user_id;
@property NSString *tattoo_image_url;
@property NSNumber *like_flag;
@property NSString *tattoo_id;
@property NSString *style_id;
@property NSString *category_id;
@property NSString *tattooShop_id;
@property NSString *tattoo_link;
@property NSString *tattoo_name;
@property NSString *artist_id;

@property TattooModel *shareTattooModel;

@property UIImage *imgCapture;
@property UIImage *imgCaptureInside;
@end
