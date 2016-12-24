//
//  MyUserProfileViewController.m
//  allotattoo
//
//  Created by My Star on 8/11/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "OtherUserProfileViewController.h"
#import "UserTattoFeedCell.h"
@interface OtherUserProfileViewController ()
{
    int cntBack;
    BOOL isShow;
    BOOL isFolllow;
    BOOL isUnFollowed;
    UserModel *userModelProfil;
    NSMutableArray *arrSortedTattooModel;
    NSMutableArray *arrSortedUserModel;
    CGFloat lastContentOffset;
}
@end
@implementation OtherUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    userModelProfil = [[UserModel alloc] init];
    [SharedModel instance].arrUserFollows = [NSMutableArray array];
    [SharedModel instance].isUserCheckedFollow = NO;
    isShow = NO;
    isFolllow = NO;
    isUnFollowed = NO;
    cntBack = 0;
    [_btnBackNav setHidden:YES];
    [_imgBack setHidden:YES];
    [_lblNavUserName setHidden:YES];
    
    [_btnBackNav setTag:0];
    [_btnBackNav addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventAllEvents];
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionFeedView.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.headerHeight = 273.0f;
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    
    [self.collectionFeedView registerNib:[UINib nibWithNibName:@"OtherUserProfileHeader" bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"OtherUserProfileHeaderVC"];
    [TattooUtilis sharedInstance].delete_sucess = 0;
    for (UserModel *userModel in [SharedModel instance].arrSharedUserModels) {
        if ([userModel.user_id isEqualToString:_userProfil_ID]) {
            userModelProfil = userModel;
            _lblNavUserName.text = userModelProfil.user_Name;
            [_imgUserProfilePIC sd_setImageWithURL:userModelProfil.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
            [self sortTattooModels];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)sortTattooModels
{
    int index = - 1;
    NSMutableArray *arrSameTattoos = [NSMutableArray array];
    NSMutableArray *arrSameUsers = [NSMutableArray array];
    for (TattooModel *tempTattooModel in [SharedModel instance].arrTattoos ) {
        index ++;
        UserModel  *searchUserModel = [SharedModel instance].arrInspiUserModels[index];
        NSString *userID = searchUserModel.user_id;
        if ([userID rangeOfString:_userProfil_ID].location != NSNotFound) {
            [arrSameTattoos addObject:tempTattooModel];
            [arrSameUsers addObject:searchUserModel];
        }
    }
    
    arrSortedUserModel = [NSMutableArray arrayWithArray:arrSameUsers];
    arrSortedTattooModel = [NSMutableArray arrayWithArray:arrSameTattoos];
    [_collectionFeedView reloadData];
}
- (void) initCustomUI:(UserModel *)userModel withOtherUserHeader:(OtherUserProfileHeader *)headerView{
    if (!isFolllow) {
        [headerView.btnOtherUserFollow setBackgroundImage:[UIImage imageNamed:@"btnMenuPlus"] forState:UIControlStateNormal];
    }else{
        [headerView.btnOtherUserFollow setBackgroundImage:[UIImage imageNamed:@"imgFollow"] forState:UIControlStateNormal];
    }
    headerView.imgOtherUserPIC.layer.backgroundColor=[[UIColor clearColor] CGColor];
    headerView.imgOtherUserPIC.layer.cornerRadius=headerView.imgOtherUserPIC.frame.size.width/2;
    headerView.imgOtherUserPIC.clipsToBounds = YES;
    headerView.imgOtherUserPIC.layer.borderColor=[[UIColor redColor] CGColor];
    [headerView.imgOtherUserPIC sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
    
    [headerView.imgOtherUserProfileBack sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
    
    
    if ([userModel.user_Name isEqualToString:@""] || userModel.user_Name == nil) {
        headerView.lblOtherUserName.text = @"No User";
    }else{
        headerView.lblOtherUserName.text = userModel.user_Name;
    }
    
    if ([userModel.userLocation isEqualToString:@""] || userModel.userLocation == nil) {
        headerView.lblOtherUserLocation.text = @"No Location";
    }else{
        headerView.lblOtherUserLocation.text = userModel.userLocation;
    }
    [FireBaseApiService onGetCommentCountWithUserID:userModel.user_id withCompletion:^(NSMutableArray *arrCommentModel) {
        if (arrCommentModel.count > 0) {
            [SharedModel instance].arrCommentWithUserID = arrCommentModel;
            headerView.lblOtherUserCommentCnt.text = [NSString stringWithFormat:@"%d",(int)[SharedModel instance].arrCommentWithUserID.count];
        }else{
            headerView.lblOtherUserCommentCnt.text = [NSString stringWithFormat:@"%d",(int)0];
        }
        [FireBaseApiService onGetFollowersWithUserID:userModel.user_id withCompletion:^(NSMutableArray *arrFollowers) {
            [SharedModel instance].isUserCheckedFollow = YES;
            if (arrFollowers.count > 0) {
                headerView.lblOtherUserFollowCnt.text = [NSString stringWithFormat:@"%d",(int)arrFollowers.count];
            }
        }];

    }];
    
//    [FireBaseApiService onGetFollowersWithUserID:userModel.user_id withCompletion:^(NSMutableArray *arrFollowers) {
//        [SharedModel instance].isUserCheckedFollow = YES;
//        if (arrFollowers.count > 0) {
//            headerView.lblOtherUserFollowCnt.text = [NSString stringWithFormat:@"%d",(int)arrFollowers.count];
//        }
//    }];
    if (arrSortedTattooModel.count > 0 && [TattooUtilis isReallyUser]) {
        headerView.lblOtherUserPostCnt.text = [NSString stringWithFormat:@"%d",(int)arrSortedTattooModel.count];
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    cntBack = 0;
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
        OtherUserProfileHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"OtherUserProfileHeaderVC" forIndexPath:indexPath];
        [self initCustomUI:userModelProfil withOtherUserHeader:headerView];
        [headerView.btnOtherUserFollow addTarget:self action:@selector(onUserFollowerTapped:) forControlEvents:UIControlEventAllEvents];
        [headerView.btnOtherUserChat addTarget:self action:@selector(onChatWithOtherUser:) forControlEvents:UIControlEventAllEvents];
        [headerView.btnOtherUserBack setTag:1];
        [headerView.btnOtherUserBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventAllEvents];
        reuseView = headerView;
    }
    return reuseView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (arrSortedTattooModel.count > 0) {
        return arrSortedTattooModel.count;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomInspirationCell *cell = (CustomInspirationCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CustomInspirationCell"                                                                                forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 0.5f;
    TattooModel *tempTattooModel = arrSortedTattooModel[indexPath.row];
    UserModel *userModel = arrSortedUserModel[indexPath.row];
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imgPhoto.layer.cornerRadius = cell.imgPhoto.frame.size.width/2;
        cell.imgPhoto.clipsToBounds  = YES;
        [cell.imgPhoto  sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
        cell.lblUserName.text = userModel.user_Name;
    });
    [cell.imgTattoo sd_setImageWithURL:[NSURL URLWithString:tempTattooModel.tattoo_image_url] placeholderImage:[UIImage imageNamed:@"img_placeholder1"]];
    if (tempTattooModel.like_flag.intValue == 0) {
        cell.imgLikePost.image = [UIImage imageNamed:@"btndislike"];
    }else{
        cell.imgLikePost.image = [UIImage imageNamed:@"btnlike"];
    }
    
//    [cell.btnProfile  addTarget:self action:@selector(onVisitUserProfile:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnLikePost addTarget:self action:@selector(onPostTattoo:event:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
#pragma UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SinglePhotoViewController *singlePhotoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SinglePhotoViewController"];
    singlePhotoVC.singleTattooModel = arrSortedTattooModel[indexPath.row];
    [self.navigationController pushViewController:singlePhotoVC animated:YES];
}
#pragma mark Scrollview delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    lastContentOffset = scrollView.contentOffset.y;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.viewNav layoutIfNeeded];
    if (lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y > 250) {
        self.constraintViewNavHeight.constant = 84.0f;
        
        [UIView animateWithDuration:0.8 animations:^{
            [_imgBack setHidden:NO];
            [_btnBackNav setHidden:NO];
            [_lblNavUserName setHidden:NO];
            [self.viewNav layoutIfNeeded];
        }];
    }else if(lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y < 250){
        self.constraintViewNavHeight.constant = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            [_imgBack setHidden:YES];
            [_btnBackNav setHidden:YES];
            [_lblNavUserName setHidden:YES];
            [self.viewNav layoutIfNeeded];
        }];
    }
    
}
#pragma mark AllEvents
- (IBAction)onUserFollowerTapped:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        if (!isFolllow) {
            isFolllow = !isFolllow;
            if (![userModelProfil isEqual:nil]) {
                [SharedModel instance].isUserFollowed = YES;
                if ([SharedModel instance].isCheckedFollow == YES) {
                    [SharedModel instance].isCheckedFollow = NO;
                }
                [self onUserFollowWithUserID:userModelProfil];
                [_collectionFeedView reloadData];
            }
        }
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }

}
- (IBAction)onChatWithOtherUser:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        if (!isShow) {
            isShow = YES;
            RecentView *recentView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentView"];
            [self.navigationController pushViewController:recentView animated:YES];
        }
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }


}

- (IBAction)onCapture:(id)sender {
    PhotoSubmitViewController *customCameraVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoSubmitViewController"];
    [self.navigationController pushViewController:customCameraVC animated:YES];
}
#pragma mark events
- (void)onBack:(id)sender {
    cntBack  ++ ;
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0 && cntBack == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == 1 && cntBack == 1){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark UserFollower
- (void)onUserFollowWithUserID:(UserModel *)userModel{
        [[[[mainRef child:USER_FOLLOW_TABLE] child:[FIRAuth auth].currentUser.uid] child:userModel.user_id] setValue:@"Follow"];
        [FireBaseApiService onGetRegistrationToken:userModel.user_id withCompletion:^(TokenModel *tokenModel) {
            if (tokenModel != nil && tokenModel.regist_token != nil) {
                [self sendPushNotificationWithFollow:tokenModel.regist_token withUserName:userModel.user_Name];
                
            }
        }];
   
}


- (void)sendPushNotificationWithFollow:(NSString *)registToken withUserName:(NSString *)userName{
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageDic = @{FOLLOW_ID:[FIRAuth auth].currentUser.uid,
                                 @"Time":time,
                                 @"CommentText":@"",
                                 @"NotificationStatus":[NSNumber numberWithInt:IS_FOLLOW_NOTIFICATION],
                                 @"ArrayTattoos":@""
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:userName];
}
- (void)onUserUnFollowWithUserID:(NSString *)userID{
    [[[[mainRef child:USER_FOLLOW_TABLE] queryOrderedByChild:FOLLOW_ID] queryEqualToValue:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists && ![SharedModel instance].isUserFollowed) {
            [SharedModel instance].isUserFollowed = YES;
            [[[mainRef child:USER_FOLLOW_TABLE] child:[[snapshot value] allKeys].lastObject] setValue:nil];
            isUnFollowed = !isUnFollowed;
        }
    }];
}
#pragma mark onVisit user profile
- (void)onVisitUserProfile:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    
    UITouch *touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touch locationInView:_collectionFeedView
                                    ];
    NSIndexPath *indexPath = [_collectionFeedView indexPathForItemAtPoint: currentTouchPosition];
    TattooModel *tempTattooModel = arrSortedTattooModel[indexPath.row];
    ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
    OtherArtistProfileViewController *otherArtistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherArtistProfileViewController"];
    if ([tempTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        artistProfileVC.artistProfil_ID = tempTattooModel.user_id;
        [self.navigationController pushViewController:artistProfileVC animated:YES];
    }else{
        otherArtistVC.artistProfil_ID = tempTattooModel.user_id;
        [self.navigationController pushViewController:otherArtistVC animated:YES];
    }
    
}
#pragma mark Click Cell Post ICON
- (void)onPostTattoo:(id)sender event:(id)event {
    if ([TattooUtilis isReallyUser]) {
        NSSet *touches = [event allTouches];
        
        UITouch *touch = [touches anyObject];
        
        CGPoint currentTouchPosition = [touch locationInView:_collectionFeedView];
        NSIndexPath *indexPath = [_collectionFeedView indexPathForItemAtPoint: currentTouchPosition];
        TattooModel *temTattoModel =  arrSortedTattooModel[indexPath.row];
        if (temTattoModel.like_flag.intValue == 0)
        {
            temTattoModel.like_flag = [NSNumber numberWithInt:1];
            [self onAddFavorTattoo:mainRef withTattooModel:temTattoModel];
            [_collectionFeedView reloadData];
            if (![temTattoModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
                [FireBaseApiService onGetRegistrationToken:temTattoModel.user_id withCompletion:^(TokenModel *tokenModel) {
                    if (tokenModel != nil && tokenModel.regist_token != nil) {
                        [self sendPushNotificationWithLike:tokenModel.regist_token withTattooID:temTattoModel.tattoo_id];
                        
                    }
                }];
            }
       }else{
            temTattoModel.like_flag = [NSNumber numberWithInt:0];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self onRemoveFavorStyleTable:mainRef withStyleModel:temTattoModel];
            [_collectionFeedView reloadData];
        } 
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }
    
}
#pragma mark send push message with Topic
- (void)sendPushNotificationWithLike:(NSString *)registToken withTattooID:(NSString *)tattooID{
    NSMutableArray *arrTattooIDs = [NSMutableArray array];
    [arrTattooIDs addObject:tattooID];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageDic = @{FOLLOW_ID:[FIRAuth auth].currentUser.uid,
                                 @"Time":time,
                                 @"CommentText":@"",
                                 @"NotificationStatus":[NSNumber numberWithInt:IS_LIKE_NOTIFICATION],
                                 @"ArrayTattoos":tattooID
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:[FIRAuth auth].currentUser.displayName];
}
#pragma mark checkFavoriteTattoo

- (void)onCheckFavoriteTattoo:(TattooModel *)tattooModel withFavorTattooArray:(NSMutableArray *)arrayFavoriteTattoos{
    for (FavorTattooModel *tmpModel in arrayFavoriteTattoos) {
        if ([tattooModel.tattoo_id isEqualToString:tmpModel.favortattoo_id]) {
            tattooModel.like_flag = [NSNumber numberWithInt:1];
            break;
        }else{
            tattooModel.like_flag = [NSNumber numberWithInt:0];
        }
    }
}

#pragma mark Post Favor Tattoo
- (void)onAddFavorTattoo:(FIRDatabaseReference *)ref withTattooModel:(TattooModel *)tattooModel{
    [[[[ref  child:FAVORTATTOO_TABLE] child:tattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid] setValue:@"Like"];
}

#pragma mark Remove TattooStyle From Favor Table
- (void)onRemoveFavorStyleTable:(FIRDatabaseReference *)ref withStyleModel:(TattooModel *)tattooModel{
    FIRDatabaseReference *removeRef = [[[ref child:FAVORTATTOO_TABLE] child:tattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid];
    [removeRef setValue:nil];
}
#pragma mark DeleteTattooModelFromFavorTattooModel
- (void)deleteFavorTattooModelFromFireBase:(FIRDatabaseReference *)deleteRef withDic:(NSDictionary *)dictionary withKeys:(NSString *)keys{
    NSError *error;
    TattooModel *tattooModel = [[TattooModel alloc] initWithDictionary:dictionary error:&error];
    if ([tattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        [[deleteRef child:keys] setValue:nil];
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

@end
