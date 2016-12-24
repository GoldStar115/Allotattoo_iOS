//
//  PhotoFeedViewController.m
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "PhotoFeedViewController.h"




@import FirebaseDatabase;
@import FirebaseStorage;
@interface PhotoFeedViewController ()
{
    int selected_format;
    NSMutableArray *arrFavorTattoos;
    NSMutableArray *arrStyles;
    NSTimer *tokenRegistTimer;
    TattooStyleViewController *tattooStyleVC;
    InspirationViewController *inspirationVC;
    MDTabBarViewController *tabBarViewController;
    
}
@property FIRDatabaseReference *favortattoo_Ref;
@property FIRDatabaseReference *style_Ref;
@end

@implementation PhotoFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
    [_imgbadge setHidden:YES];


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateBadge:) name:@"Updatebadge" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView:) name:@"ChangeRootView" object:nil];
    
   
    
    [self viewSearchFeedHidden];
    
    NSLog(@"Instance Token %@",[FIRInstanceID instanceID].token);
    [FireBaseApiService onGetRegistrationToken:[FIRAuth auth].currentUser.uid withCompletion:^(TokenModel *tokenModel) {
        if (tokenModel.regist_token != nil && ![tokenModel.regist_token isEqualToString:@""]) {
            if ([tokenModel.regist_token isEqualToString:[FIRInstanceID instanceID].token]) {
                return ;
            }else if (![[FIRInstanceID instanceID].token isEqualToString:@""] && [FIRInstanceID instanceID].token != nil){
                [self registToken];
            }
        }else{
            if (![[FIRInstanceID instanceID].token isEqualToString:@""] && [FIRInstanceID instanceID].token != nil) {
                [self registToken];
            }else{
                tokenRegistTimer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(onCheckTokenValid:) userInfo:nil repeats:YES];
            }
        }
    }];
    
    tattooStyleVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TattooStyleViewController"];
    inspirationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"InspirationViewController"];
    [self initCustomizeSearchBar];
    [self initValue];
    [self initTabBarController];

}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
  
        
}
- (void)viewDidAppear:(BOOL)animated
{

    [super viewDidAppear:animated];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self viewSearchFeedHidden];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark MDTabBarViewController
- (void)initTabBarController{
    tabBarViewController = [[MDTabBarViewController alloc] initWithDelegate:self];
    NSArray *names = @
    [
        @"INSPIRATIONS",@"CATÉGORIES"
    ];
    [tabBarViewController setItems:names];
    tabBarViewController.tabBar.selectedIndex = [SharedModel instance].feedIndex ;
    [self addChildViewController:tabBarViewController];
    [self.view addSubview:tabBarViewController.view];
    [tabBarViewController didMoveToParentViewController:self];
    UIView *controllerView = tabBarViewController.view;
    id<UILayoutSupport> rootTopLayoutGuide = self.topLayoutGuide;
    id<UILayoutSupport> rootBottomLayoutGuide = self.bottomLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(
                                                                   rootTopLayoutGuide, rootBottomLayoutGuide, controllerView);
    [self.view
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"V:[rootTopLayoutGuide]-56-["@"controllerView]["@"rootBottomLayoutGuide]"
                     options:0
                     metrics:nil
                     views:viewsDictionary]];
    [self.view
     addConstraints:[NSLayoutConstraint
                     constraintsWithVisualFormat:@"H:|[controllerView]|"
                     options:0
                     metrics:nil
                     views:viewsDictionary]];
}
#pragma mark MDTabBarViewControllerDelegate
- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController viewControllerAtIndex:(NSUInteger)index
{
    UIViewController *vc;
    switch (index) {
        case 0:
            [SharedModel instance].feedIndex = 0;
            [_btnSearch setHidden:NO];
            vc = inspirationVC;
            break;
        case 1:
            [SharedModel instance].feedIndex = 1;
            [self viewSearchFeedHidden];
            [_btnSearch setHidden:YES];
            vc = tattooStyleVC;
            break;
    }
    return vc;
}
- (void)tabBarViewController:(MDTabBarViewController *)viewController didMoveToIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            [SharedModel instance].feedIndex = 0;
            [_btnSearch setHidden:NO];
            break;
        case 1:
            [SharedModel instance].feedIndex = 1;
            [self viewSearchFeedHidden];
            [_btnSearch setHidden:YES];
            break;
    }
}
#pragma mark changeRootViewController
- (void)changeRootView:(NSNotification *)notification{
    if ([notification.name isEqualToString:@"ChangeRootView"]) {
        NotificationModel *notiModel = notification.userInfo[@"notiDic"];
        if (notiModel != nil) {
            NotificationViewController *notificationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
            [self.navigationController pushViewController:notificationVC animated:YES];
//            if(notiModel.numStatus.intValue == IS_FOLLOW_NOTIFICATION)
//            {
//                ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
//                OtherArtistProfileViewController *otherArtistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherArtistProfileViewController"];
//                if ([notiModel.strUserID isEqualToString:[FIRAuth auth].currentUser.uid]) {
//                    [self.navigationController pushViewController:artistProfileVC animated:NO];
//                }else{
//                    [self.navigationController pushViewController:otherArtistVC animated:NO];
//                }
//            }
//            else if(notiModel.numStatus.intValue == IS_LIKE_NOTIFICATION)
//            {
//                PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
//                [SharedModel instance].feedIndex = 0;
//                [SharedModel instance].isInsFiltered = NO;
//                [[SharedModel instance].arrInsTattooSearchResult removeAllObjects];
//                [[SharedModel instance].arrInsUserSearchResult removeAllObjects];
//                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:NO];
//                [self.sideMenuViewController hideMenuViewController];
//                
//            }
//            else if(notiModel.numStatus.intValue == IS_COMMENT_NOTIFICATION)
//            {
//                SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
//                for (TattooModel *tattooModel in [SharedModel instance].arrTattoos) {
//                    if ([notiModel.arrTattooIDs isEqualToString:tattooModel.tattoo_id]) {
//                        singlePhotoVC.singleTattooModel = tattooModel;
//                    }
//                }
//                [self.navigationController pushViewController:singlePhotoVC animated:YES];
//                
//            }
//            else if(notiModel.numStatus.intValue == IS_MESSAGE_NOTIFICATION)
//            {
//                RecentView *recentView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentView"];
//                [self.navigationController pushViewController:recentView animated:NO];
//            }

        }
    }
}
- (void)handleUpdateBadge:(NSNotification *)notifcation
{
    NSNumber *cnt_num = [notifcation.userInfo objectForKey:@"badgecount"];
    if ([notifcation.name isEqualToString:@"Updatebadge"] && cnt_num.intValue > 0) {
        [self.imgbadge setHidden:NO];
    }
    
}
- (void)initCustomizeSearchBar
{
    _txtSearchFiled.delegate = self;
    _txtSearchFiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"RECHERCHER" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    _viewFeedSearch.layer.cornerRadius = 3.0f;
    _viewFeedSearch.layer.masksToBounds = YES;
    
}
- (void) initValue{
    
    if ([SharedModel instance].arrNotificationModel.count > 0) {
        [_imgbadge setHidden:NO];
    }else{
        [_imgbadge setHidden:YES];
    }
    arrFavorTattoos = [NSMutableArray array];
    arrStyles = [NSMutableArray array];
}
- (void)deleteToken{
    [[[mainRef child:REGISTTOKEN_TABLE] child:[FIRAuth auth].currentUser.uid] setValue:nil];
}
#pragma mark RegisterationTokenGet
- (void)registToken{

    FIRDatabaseReference *ref = [[mainRef child:REGISTTOKEN_TABLE] child:[FIRAuth auth].currentUser.uid];
    NSDictionary *tokenModel = @{USER_ID:[FIRAuth auth].currentUser.uid,
                                 USER_REGISTERATIONTOKEN:[FIRInstanceID instanceID].token,
                                 TOKEN_KEY:ref.key
                                 };
    [ref setValue:tokenModel];
}
#pragma mark TokenValid
- (void)onCheckTokenValid:(NSTimer *)timer{
    if (![[FIRInstanceID instanceID].token isEqualToString:@""] && [FIRInstanceID instanceID].token != nil) {
        NSLog(@"CountTimer %@",@"Timer");
        [self registToken];
        [tokenRegistTimer invalidate];
        tokenRegistTimer = nil;
    }
}
#pragma mark failedAlertAction
- (void)failedAlertAction:(NSString*)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:nil
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Ok"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
/////////////////////////////////////

#pragma mark SegmentControl
- (IBAction)onLikeTattoo:(id)sender {
    WishListViewController *wishListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
    wishListVC.loginedFlag = YES;
    
    WishListNoViewController *wishNoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WishListNoViewController"];
    MesFavorisViewController *mesFavorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MesFavorisViewController"];
    mesFavorVC.arrMesFavorisImage = [NSMutableArray array];
    mesFavorVC.arrMesFavorisImage = [TattooUtilis onGetFavorTattooFromTattooModel:[SharedModel instance].arrTattoos];
    if (mesFavorVC.arrMesFavorisImage.count > 0 && [FIRAuth auth].currentUser && [TattooUtilis isReallyUser]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                mesFavorVC.arrMesFavorisImage = [TattooUtilis onGetFavorTattooFromTattooModel:[SharedModel instance].arrTattoos];
                [self.navigationController pushViewController:mesFavorVC animated:YES];
            });
    }else if(mesFavorVC.arrMesFavorisImage.count <= 0 && [FIRAuth auth].currentUser && [TattooUtilis isReallyUser])
    {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:wishNoVC animated:YES];
            });
            
    }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                wishListVC.loginedFlag  = NO;
                [self.navigationController pushViewController:wishListVC animated:YES];
            });
            
    }


}

- (IBAction)onSearchTattoo:(id)sender {
    [self viewSearchFeedShow];
   
}
- (void)viewSearchFeedShow{
    NSLog(@"FeedIndex = %d",(int)[SharedModel instance].feedIndex);
    if ([SharedModel instance].feedIndex == 0) {
        [_imgMenu setHidden:YES];
        [_btnMenu setHidden:YES];
        [_btnLike setHidden:YES];
        [_btnSearch setHidden:YES];
        [_imgTitleLogo setHidden:YES];
        [_viewFeedSearch setHidden:NO];
        [_btnSearchBack setHidden:NO];
        [_btnSearchDismiss setHidden:NO];
        [_txtSearchFiled setHidden:NO];
    }
}
- (void)viewSearchFeedHidden{
    [_imgMenu setHidden:NO];
    [_btnMenu setHidden:NO];
    [_btnLike setHidden:NO];
    if ([SharedModel instance].feedIndex == 0){
        [_btnSearch setHidden:NO];
    }else{
        [_btnSearch setHidden:YES];
    }
    [_imgTitleLogo setHidden:NO];
    [_viewFeedSearch setHidden:YES];
    [_btnSearchBack setHidden:YES];
    [_btnSearchDismiss setHidden:YES];
    [_txtSearchFiled setHidden:YES];
    _txtSearchFiled.text = @"";
    [self.view endEditing:YES];
}
- (IBAction)onShowMenu:(id)sender {
    [self.sideMenuViewController presentLeftMenuViewController];
}

#pragma mark SearchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
  
    NSDictionary *searchInfo = [NSDictionary dictionaryWithObjectsAndKeys:searchText,@"searchtext", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchTattoos" object:self  userInfo:searchInfo];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self viewSearchFeedHidden];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self viewSearchFeedHidden];
}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self viewSearchFeedHidden];
}
#pragma mark OnScreenCpature
- (UIImage *)onScreenCapture{
    UIGraphicsBeginImageContext(CGSizeMake(60, self.view.frame.size.height));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark SearchhTextFieldDelegate
- (IBAction)onSearchDissmissTapped:(id)sender {

    NSDictionary *searchInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"searchtext", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchTattoos" object:self  userInfo:searchInfo];
    [self viewSearchFeedHidden];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _txtSearchFiled.text = @"";
    [_btnSearchDismiss setHidden:NO];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self viewSearchFeedHidden];
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)txtFieldDidChangeText:(id)sender {
    UITextField *txtFiled = (UITextField *)sender;
    NSDictionary *searchInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtFiled.text,@"searchtext", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchTattoos" object:self  userInfo:searchInfo];
}

@end
