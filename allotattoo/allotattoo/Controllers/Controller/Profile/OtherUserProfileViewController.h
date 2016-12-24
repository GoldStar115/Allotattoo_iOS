//
//  MyUserProfileViewController.h
//  allotattoo
//
//  Created by My Star on 8/11/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomInspirationCell.h"
#import "CollectionCustomViewFlowLayout.h"
#import "UserTattoFeedCell.h"
#import "UserModel.h"
#import "Constant.h"
#import "ArtistProfileViewController.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "OtherUserProfileHeader.h"
#import "NotationViewController.h"
@interface OtherUserProfileViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintViewNavHeight;

@property (weak, nonatomic) IBOutlet UIView *viewNav;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserProfilePIC;
@property (weak, nonatomic) IBOutlet UILabel *lblNavUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgBack;
@property (weak, nonatomic) IBOutlet UIButton *btnBackNav;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionFeedView;
@property NSString *userProfil_ID;
@end
