//
//  MyArtistProfileViewController.h
//  allotattoo
//
//  Created by My Star on 8/11/16.
//  Copyright © 2016 My Star. All rights reserved.
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
#import <SDWebImage/UIImageView+WebCache.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "OtherArtistProfileHeader.h"
#import "NotationViewController.h"
@interface OtherArtistProfileViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionFeed;
@property (weak, nonatomic) IBOutlet UIView *viewNav;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewNavHeight;

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;

@property (weak, nonatomic) IBOutlet UILabel *lblNavUsername;
@property NSArray *arrTattooPhotos;

@property NSString *artistProfil_ID;


@end
