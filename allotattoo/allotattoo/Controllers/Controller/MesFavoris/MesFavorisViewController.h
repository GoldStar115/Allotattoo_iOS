//
//  MesFavorisViewController.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MesFavorisCell.h"
#import "CollectionCustomViewFlowLayout.h"
#import "PhotoFeedViewController.h"
#import <MBProgressHUD.h>
#import "FavorTattooModel.h"
#import "SharedModel.h"
#import "TattooModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "OtherArtistProfileViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"

@interface MesFavorisViewController : UIViewController<CHTCollectionViewDelegateWaterfallLayout,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionMesFavoris;
@property NSMutableArray *arrMesFavorisImage;
@end
