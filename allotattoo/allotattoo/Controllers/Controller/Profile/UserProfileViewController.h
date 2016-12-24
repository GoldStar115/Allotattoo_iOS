//
//  UserProfileViewController.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomInspirationCell.h"
#import "CollectionCustomViewFlowLayout.h"
#import "UserTattoFeedCell.h"
#import "UserModel.h"
#import "Constant.h"
#import "ArtistProfileViewController.h"
#import "AlloTattoAppDelegate.h"
#import <DBCameraContainerViewController.h>
#import <DBCameraViewController.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "UserProfileHeaderView.h"
@interface UserProfileViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,UpdateBadgeNumberDelegate,DBCameraViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionUserTattoFeed;
@property NSArray *arrTattooPhotos;

@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UILabel *lblNavUserName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewNavHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgNavUserPic;


@property NSString *userProfil_ID;
@end
