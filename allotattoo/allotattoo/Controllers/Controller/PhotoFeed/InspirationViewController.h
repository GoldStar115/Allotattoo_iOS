//
//  InspirationViewController.h
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "CustomInspirationCell.h"
#import "CollectionCustomViewFlowLayout.h"
#import "SinglePhotoViewController.h"
#import "ArtistProfileViewController.h"
#import "PhotoSubmitViewController.h"
#import <MBProgressHUD.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "TattooModel.h"
#import "SharedModel.h"
#import "FavorTattooModel.h"
#import "PhotoFeedViewController.h"
#import "MesFavorisViewController.h"
#import "FireBaseApiService.h"
#import "OtherArtistProfileViewController.h"
#import <DBCameraContainerViewController.h>
#import <DBCameraViewController.h>
#import "CHTCollectionViewWaterfallLayout.h"
#import "NotationViewController.h"

@import FirebaseDatabase;
@import FirebaseStorage;
@import Firebase;

@interface InspirationViewController : UIViewController<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,UICollectionViewDelegate,DBCameraViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectioViewInspiration;
@property NSMutableArray *arrTattooPhotos;
@property (weak, nonatomic) IBOutlet UIView *viewSuccessPost;
@property (weak, nonatomic) IBOutlet UILabel *lblSuccessPost;

@property (nonatomic, strong) NSArray *cellSizes;
//@property FIRDatabaseReference *tattoo_Ref;
//@property FIRDatabaseReference *favor_Ref;

@end
