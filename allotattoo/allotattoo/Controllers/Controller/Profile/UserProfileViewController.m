//
//  UserProfileViewController.m
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "UserProfileViewController.h"
#import <RESideMenu.h>
#import "SinglePhotoViewController.h"
#import "ProfileSettingViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
#import "PhotoSubmitViewController.h"
@interface UserProfileViewController ()
{
    BOOL isShow;
    BOOL isFolllow;
    BOOL isUnFollowed;
    UserModel *userModelProfil;
    NSMutableArray *arrUserTattoos;
    CGFloat lastContentOffset;
    
}
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

    
    [_lblNavUserName setHidden:YES];
    [self.viewNavigation layoutIfNeeded];
    self.constraintViewNavHeight.constant = 0.0f;
    [self.viewNavigation layoutIfNeeded];
    
    [AlloTattoAppDelegate sharedDelegate].delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateBadge:) name:@"MenuUpdateUser" object:nil];
    
    userModelProfil = [[UserModel alloc] init];
    [SharedModel instance].arrUserFollows = [NSMutableArray array];
    [SharedModel instance].isUserCheckedFollow = NO;
    arrUserTattoos = [NSMutableArray array];
    
    isShow = NO;
    isFolllow = NO;
    isUnFollowed = NO;
    
    [TattooUtilis sharedInstance].delete_sucess = 0;
    [_lblNavUserName setHidden:YES];
    [_imgBack setHidden:YES];
    [_btnBack setHidden:YES];

    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionUserTattoFeed.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.headerHeight = 273.0f;
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    
    [self.collectionUserTattoFeed registerNib:[UINib nibWithNibName:@"UserProfileHeaderView" bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"UserProfileHeaderVC"];
    if (![TattooUtilis isReallyUser]) {
        arrUserTattoos = [SharedModel instance].arrTattoos;
        _lblNavUserName.text = @"No User";
        [_collectionUserTattoFeed reloadData];
    }else{
        if ([TattooUtilis getUserModel] != nil) {
            userModelProfil = [[UserModel alloc] initWithDictionary:[TattooUtilis getUserModel] error:nil];
            _lblNavUserName.text = userModelProfil.user_Name;
            [_imgNavUserPic sd_setImageWithURL:userModelProfil.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
            for (TattooModel *tempModel in [SharedModel instance].arrTattoos)
            {
                NSString *userID = tempModel.user_id;
                if ([userID rangeOfString:userModelProfil.user_id].location != NSNotFound) {
                    [arrUserTattoos addObject:tempModel];
                }
            }
            [_collectionUserTattoFeed reloadData];
            
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [FireBaseApiService onGetUserInfoFromFireBase:[FIRAuth auth].currentUser.uid withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                userModelProfil = userModel;
                [TattooUtilis removeModel:USER_MODEL];
                [TattooUtilis saveUserModel:[TattooUtilis parseFromUserModel:userModel]];
                if (userModelProfil != nil) {
                    _lblNavUserName.text = userModelProfil.user_Name;
                    [_imgNavUserPic sd_setImageWithURL:userModelProfil.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
                    for (TattooModel *tempModel in [SharedModel instance].arrTattoos)
                    {
                        NSString *userID = tempModel.user_id;
                        if ([userID rangeOfString:userModelProfil.user_id].location != NSNotFound) {
                            [arrUserTattoos addObject:tempModel];
                        }
                    }
                    [_collectionUserTattoFeed reloadData];
                }
            } failure:^(NSError *error) {
                NSLog(@"error %@",error.localizedDescription);
            }];
        }
    }
}
- (void)updateDadgeNumber:(NSInteger)counter
{
    if (counter > 0) {
        
    }
}
- (void)handleUpdateBadge:(NSNotification *)notifcation
{
    NSNumber *cnt_num = [notifcation.userInfo objectForKey:@"badgecount"];
    if ([notifcation.name isEqualToString:@"MenuUpdateUser"] && cnt_num.intValue > 0) {
       
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void) initCustomUI:(UserModel *)userModel withUserProfielViewHeader:(UserProfileHeaderView *)headerView{
    if ([SharedModel instance].arrNotificationModel.count > 0) {
        [headerView.imgBadge setHidden:NO];
    }else{
        [headerView.imgBadge setHidden: YES];
    }
    headerView.imgUserPic.layer.backgroundColor=[[UIColor clearColor] CGColor];
    headerView.imgUserPic.layer.cornerRadius=headerView.imgUserPic.frame.size.width/2;
    headerView.imgUserPic.clipsToBounds = YES;
    headerView.imgUserPic.layer.borderColor=[[UIColor redColor] CGColor];
    [headerView.imgUserPic sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
    [headerView.imgUserProfileBack sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
    if ([userModel.user_Name isEqualToString:@""] || userModel.user_Name == nil) {
        headerView.lblUserName.text = @"No User";
    }else{
        headerView.lblUserName.text = userModel.user_Name;
    }

    if ([userModel.userLocation isEqualToString:@""] || userModel.userLocation == nil) {
        headerView.lblUserLocation.text = @"No Location";
    }else{
        headerView.lblUserLocation.text = userModel.userLocation;
    }
    [FireBaseApiService onGetCommentCountWithUserID:userModel.user_id withCompletion:^(NSMutableArray *arrCommentModel) {
        if (arrCommentModel.count > 0) {
            [SharedModel instance].arrCommentWithUserID = arrCommentModel;
            headerView.lblCommentCnt.text = [NSString stringWithFormat:@"%d",(int)arrCommentModel.count];
        }else{
            headerView.lblCommentCnt.text = [NSString stringWithFormat:@"%d",(int)0];
            
        }
    }];
    [FireBaseApiService onGetFollowersWithUserID:userModel.user_id withCompletion:^(NSMutableArray *arrFollowers) {
        [SharedModel instance].isUserCheckedFollow = YES;
        if (arrFollowers.count > 0) {
            [SharedModel instance].arrUserFollows = arrFollowers;
            headerView.lblFollowerCnt.text = [NSString stringWithFormat:@"%d",(int)arrFollowers.count];
        }
    }];
    if (arrUserTattoos.count > 0 && [TattooUtilis isReallyUser]) {
            headerView.lblPostCnt.text = [NSString stringWithFormat:@"%d",(int)arrUserTattoos.count];
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UICollectionViewHeaderDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseView = nil;
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        UserProfileHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"UserProfileHeaderVC" forIndexPath:indexPath];
        [self initCustomUI:userModelProfil withUserProfielViewHeader:headerView];
        [headerView.btnMenu addTarget:self action:@selector(onShowProfileMenu:) forControlEvents:UIControlEventAllEvents];
        [headerView.btnProfileSetting addTarget:self action:@selector(onShowUserProfileSetting:) forControlEvents:UIControlEventAllEvents];
        reuseView = headerView;
    }
    return reuseView;
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (arrUserTattoos.count > 0) {
        return arrUserTattoos.count;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UserTattoFeedCell *cell = (UserTattoFeedCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserTattoFeedCell"                                                                                forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    TattooModel *tempTattooModel = arrUserTattoos[indexPath.row];
    [cell.imgTatto sd_setImageWithURL:[NSURL URLWithString:tempTattooModel.tattoo_image_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
    [FireBaseApiService onGetFavorTattooFromWithTattooIDFireBase:tempTattooModel.tattoo_id withQuery:nil withCompleteion:^(NSMutableArray *arrFavorTattoo) {
        tempTattooModel.like_number = [NSNumber numberWithInteger:arrFavorTattoo.count];
        if (tempTattooModel.like_number.intValue > 0) {
            cell.imgListPost.image = [UIImage imageNamed:@"btnlike"];
            cell.lblUserLikeNumber.text = [NSString stringWithFormat:@"%d",tempTattooModel.like_number.intValue];
            
        }else{
            cell.imgListPost.image = [UIImage imageNamed:@"btndislike"];
            cell.lblUserLikeNumber.text = [NSString stringWithFormat:@"%d",0];
            
        }
    } failure:^(NSError *error) {
        
    }];
    [FireBaseApiService onGetCommentCount:tempTattooModel.tattoo_id withCompletion:^(NSMutableArray *arrComment) {
        [SharedModel instance].arrCommentWithTattooID  = arrComment;
        tempTattooModel.comment_number = [NSNumber numberWithInteger:[SharedModel instance].arrCommentWithTattooID.count];
        cell.lblUserCommitNumber.text = [NSString stringWithFormat:@"%d",tempTattooModel.comment_number.intValue];
        
    }];

    

    return cell;
}
#pragma UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
    singlePhotoVC.singleTattooModel = arrUserTattoos[indexPath.row];
    [self.navigationController pushViewController:singlePhotoVC animated:YES];
}
#pragma mark - CollectionViewDelegateWaterFallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    CGFloat width = 0;
    int scaleFactor = 0;
    scaleFactor = (int)indexPath.row % 4;
    switch (scaleFactor) {
        case 0:
            //            height = self.view.frame.size.height/factor;
            height = 230;
            break;
        case 1:
            //            height = self.view.frame.size.height/factor + 60 ;
            height = 290;
            break;
        case 2:
            //            height = self.view.frame.size.height/factor + 60;
            height = 290;
            break;
        case 3:
            height = 230;
            break;
        default:
            break;
    }
    width = self.view.frame.size.width/2 - 10;
    return CGSizeMake(width, height);
}
#pragma mark Scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewNavigation layoutIfNeeded];
    if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 250) {
        self.constraintViewNavHeight.constant = 84.0f;
        [UIView animateWithDuration:0.8 animations:^{
            [self.viewNavigation layoutIfNeeded];
            [_lblNavUserName setHidden:NO];
            [_imgBack setHidden:NO];
            [_btnBack setHidden:NO];
        }];
    }else if(lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y < 250){
        self.constraintViewNavHeight.constant = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            [_lblNavUserName setHidden:YES];
            [_imgBack setHidden:YES];
            [_btnBack setHidden:YES];
            [self.viewNavigation layoutIfNeeded];
        }];
    }

}




#pragma mark onShowAction

- (IBAction)onShowProfileMenu:(id)sender {
//    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[self onScreenCapture],@"image", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateImage" object:self userInfo:userInfo];
    [self.sideMenuViewController presentLeftMenuViewController];
}
#pragma mark OnScreenCpature
- (UIImage *)onScreenCapture{
    UIGraphicsBeginImageContext(CGSizeMake(60, self.view.frame.size.height));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (IBAction)onShowUserProfileSetting:(id)sender {
    ProfileSettingViewController *profileSettingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileSettingViewController"];
    [self presentViewController:profileSettingVC animated:YES completion:nil];
}
- (IBAction)onBackTapped:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

#pragma mark OnCamera
- (IBAction)onCameraOpen:(id)sender {
    [self openCamera];
}

#pragma mark Open Camera
- (void) openCamera
{
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - DBCameraViewControllerDelegate

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    PhotoSubmitViewController *customCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoSubmitViewController"];
    dispatch_async(dispatch_get_main_queue(), ^{
        customCameraVC.imageCaptured = image;
    });
    [self.presentedViewController dismissViewControllerAnimated:NO completion:(^{
        [self.navigationController pushViewController:customCameraVC animated:YES];
    })];
}

- (void) dismissCamera:(id)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
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

@end
