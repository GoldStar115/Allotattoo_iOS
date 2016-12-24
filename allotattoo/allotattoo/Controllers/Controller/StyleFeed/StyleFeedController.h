//
//  StyleFeedController.h
//  AllTattoo
//
//  Created by My Star on 7/2/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionCustomViewFlowLayout.h"
#import "StyleCategoryCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "StyleInspirationCell.h"
#import <DBCameraContainerViewController.h>
#import "NotationViewController.h"

#define TAG_CATEGORY 0
#define TAG_FEED     1
@interface StyleFeedController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,CHTCollectionViewDelegateWaterfallLayout,UISearchBarDelegate,DBCameraViewControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionCategory;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionInspiration;

@property (weak, nonatomic) IBOutlet UIImageView *imgSection;

@property (weak, nonatomic) IBOutlet UIImageView *imgNavigation;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryTitle;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchBack;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchDismiss;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewSearchBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imgBtnBack;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarStyle;
@property NSString *style_id;
@property NSString *style_title;

@end
