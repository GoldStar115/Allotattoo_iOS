//
//  ArtistProfileViewController.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomInspirationCell.h"
#import "CollectionCustomViewFlowLayout.h"
#import "Constant.h"
#import <MBProgressHUD.h>
#import "utilities.h"
#import "RecentView.h"
#import "SinglePhotoViewController.h"
#import "PhotoSubmitViewController.h"
#import "UserTattoFeedCell.h"
#import "AlloTattoAppDelegate.h"
#import <DBCameraContainerViewController.h>
#import <DBCameraViewController.h>
#import "ArtistProfileHeaderView.h"
#import "CHTCollectionViewWaterfallLayout.h"
@interface ArtistProfileViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,DBCameraViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionFeed;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistName;
@property (weak, nonatomic) IBOutlet UIView *viewNav;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewNav;

@property NSArray *arrTattooPhotos;
@property UserModel *artistModelProfil;
@property NSString *artistProfil_ID;
@end
