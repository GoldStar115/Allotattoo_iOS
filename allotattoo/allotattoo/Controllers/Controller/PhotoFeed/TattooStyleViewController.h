//
//  TattooStyleViewController.h
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "Constant.h"


#import "PhotoFeedViewController.h"
#import "StyleCell.h"
#import "StyleInviteFooterCell.h"
#import "StylePostFooterCell.h"
#import "StyleFeedController.h"
#import "PhotoSubmitViewController.h"
#import "MemberTypeViewController.h"
#import "SharedModel.h"
#import "StyleModel.h"
#import "FavorStyleModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import <DBCameraContainerViewController.h>
#import <DBCameraViewController.h>
#import "NotationViewController.h"
#import <FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <MGInstagram.h>
#import <AAShareBubbles.h>


@import Firebase;
@import FirebaseStorage;
@import FirebaseDatabase;

@interface TattooStyleViewController : UIViewController<AAShareBubblesDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblStyle;
@property NSMutableArray *arrayStyleImage;


@end
