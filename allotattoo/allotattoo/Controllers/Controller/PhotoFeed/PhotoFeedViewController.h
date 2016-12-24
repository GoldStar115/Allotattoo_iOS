//
//  PhotoFeedViewController.h
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RESideMenu.h>
#import "Constant.h"
#import "FireBaseApiService.h"
#import "InspirationViewController.h"
#import "WishListViewController.h"
#import "FavorTattooModel.h"
#import <MBProgressHUD.h>
#import "TattooModel.h"
#import "StyleModel.h"
#import "SharedModel.h"
#import "UserModel.h"
#import "TattooStyleViewController.h"
#import "MesFavorisViewController.h"
#import "WishListNoViewController.h"
#import <MDTabBarViewController.h>
#import "NotificationViewController.h"



@interface PhotoFeedViewController : UIViewController<RESideMenuDelegate,UISearchBarDelegate,UITextFieldDelegate,MDTabBarViewControllerDelegate>


@property (weak, nonatomic) IBOutlet UIView *viewNavigation;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property UIViewController *currentViewController;
@property (weak, nonatomic) IBOutlet UIView *viewSegment;
@property (weak, nonatomic) IBOutlet UIButton *btnMenu;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIView *viewFeedSearch;
@property (weak, nonatomic) IBOutlet UIImageView *imgTitleLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imgMenu;
@property (weak, nonatomic) IBOutlet UIImageView *imgbadge;

@property NSInteger feedIndex;

@property (weak, nonatomic) IBOutlet UIButton *btnSearchBack;
@property (weak, nonatomic) IBOutlet UIButton *btnSearchDismiss;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchFiled;
@property id credential;




@end
