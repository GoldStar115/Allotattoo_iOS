//
//  MyArtistProfileViewController.m
//  allotattoo
//
//  Created by My Star on 8/11/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "OtherArtistProfileViewController.h"
@interface OtherArtistProfileViewController ()
{
    int cntBtnBack;
    BOOL isChat;
    BOOL isFolllow;
    BOOL isBack;
    UserModel *artistModelProfil;
    NSMutableArray *arrSortedTattooModel;
    NSMutableArray *arrSortedUserModel;
    CGFloat lastContentOffset;
}
@end
@implementation OtherArtistProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    artistModelProfil = [[UserModel alloc] init];
    [SharedModel instance].arrUserFollows = [NSMutableArray array];
    [SharedModel instance].isUserCheckedFollow = NO;
    
    isChat = NO;
    isFolllow = NO;
    isBack = NO;
    cntBtnBack = 0;

    [_btnBack setHidden:YES];
    [_imgBack setHidden:YES];
    [_lblNavUsername setHidden:YES];
    
    [_btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventAllEvents];
    [_btnBack setTag:0];
    
    CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionFeed.collectionViewLayout;
    layout.sectionInset = UIEdgeInsetsMake(7, 7, 7, 7);
    layout.headerHeight = 273.0f;
    layout.minimumColumnSpacing = 7.0f;
    layout.minimumInteritemSpacing = 7.0f;
    
    [self.collectionFeed registerNib:[UINib nibWithNibName:@"OtherArtistProfileHeader" bundle:nil] forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader withReuseIdentifier:@"OtherArtistProfileHeaderVC"];
    for (UserModel *userModel in [SharedModel instance].arrSharedUserModels) {
        if ([userModel.user_id isEqualToString:_artistProfil_ID]) {
            artistModelProfil = userModel;
            _lblNavUsername.text = artistModelProfil.user_Name;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self sortTattooModels];
            });
        }
    }
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
        if ([userID rangeOfString:_artistProfil_ID].location != NSNotFound) {
            [arrSameTattoos addObject:tempTattooModel];
            [arrSameUsers addObject:searchUserModel];
        }
    }
    
    arrSortedUserModel = [NSMutableArray arrayWithArray:arrSameUsers];
   arrSortedTattooModel = [NSMutableArray arrayWithArray:arrSameTattoos];
   [_collectionFeed reloadData];
}
- (void) initCustomUI:(UserModel *)artistModel withOtherArtistHeader:(OtherArtistProfileHeader *)headerView{    
    if (!isFolllow) {
        [headerView.btnFollowOtherArtist setBackgroundImage:[UIImage imageNamed:@"btnMenuPlus"] forState:UIControlStateNormal];
    }else{
        [headerView.btnFollowOtherArtist setBackgroundImage:[UIImage imageNamed:@"imgFollow"] forState:UIControlStateNormal];
    }
    headerView.imgOtherArtistPic.layer.backgroundColor=[[UIColor clearColor] CGColor];
    headerView.imgOtherArtistPic.layer.cornerRadius=headerView.imgOtherArtistPic.frame.size.width/2;
    headerView.imgOtherArtistPic.clipsToBounds = YES;
    headerView.imgOtherArtistPic.layer.borderColor=[[UIColor redColor] CGColor];
    [headerView.imgOtherArtistPic sd_setImageWithURL:artistModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
    
    if ([artistModel.user_Name isEqualToString:@""] && artistModel.user_Name == nil) {
        headerView.lblOtherArtistName.text = @"Nicalas Stouls";
    }else{
        headerView.lblOtherArtistName.text = artistModel.user_Name;
    }
    
    if ([artistModel.userLocation isEqualToString:@""] && artistModel.userLocation == nil) {
        headerView.lblOtherArtistLocation.text = @"Paris";
    }else{
        headerView.lblOtherArtistLocation.text = artistModel.userLocation;
    }
    [FireBaseApiService onGetFollowersWithUserID:artistModel.user_id withCompletion:^(NSMutableArray *arrFollowers) {
        [SharedModel instance].isUserCheckedFollow = YES;
        if (arrFollowers.count > 0) {
            headerView.lblOtherArtistFollowCnt.text = [NSString stringWithFormat:@"%d",(int)arrFollowers.count];
        }
    }];
    [FireBaseApiService onGetCommentCountWithUserID:artistModel.user_id withCompletion:^(NSMutableArray *arrCommentModel) {
        if (arrCommentModel.count > 0) {
            [SharedModel instance].arrCommentWithUserID = arrCommentModel;
            headerView.lblOtherArtistCommentCnt.text = [NSString stringWithFormat:@"%d",(int)[SharedModel instance].arrCommentWithUserID.count];
        }else{
            headerView.lblOtherArtistCommentCnt.text = [NSString stringWithFormat:@"%d",(int)0];
        }

    }];
    

    if (arrSortedTattooModel.count > 0) {
            headerView.lblOtherArtistPostCnt.text = [NSString stringWithFormat:@"%d",(int)arrSortedTattooModel.count];
    }

    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    cntBtnBack = 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    isChat = NO;
    isFolllow = NO;
    [SharedModel instance].isUserCheckedFollow = NO;

}

#pragma mark UICollectionViewHeaderDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reuseView = nil;
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        OtherArtistProfileHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"OtherArtistProfileHeaderVC" forIndexPath:indexPath];
        [self initCustomUI:artistModelProfil withOtherArtistHeader:headerView];
        [headerView.btnFollowOtherArtist addTarget:self action:@selector(onUserFollowerTapped:headerView:) forControlEvents:UIControlEventAllEvents];
        [headerView.btnChatWithOtherArtist addTarget:self action:@selector(onChatWithOtherUser:) forControlEvents:UIControlEventAllEvents];
        [headerView.btnBack setTag:1];
        [headerView.btnBack addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventAllEvents];
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
    [[[[mainRef child:FAVORTATTOO_TABLE] child:tempTattooModel.tattoo_id] child:[FIRAuth auth].currentUser.uid] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if ([snapshot exists]) {
            tempTattooModel.like_flag = [NSNumber numberWithInt:1];
            cell.imgLikePost.image = [UIImage imageNamed:@"btnlike"];
        }else{
            tempTattooModel.like_flag = [NSNumber numberWithInt:0];
            cell.imgLikePost.image = [UIImage imageNamed:@"btndislike"];
        }
    }];
    
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
    if (lastContentOffset < scrollView.contentOffset.y  && scrollView.contentOffset.y > 250) {
        self.constraintViewNavHeight.constant = 84.0f;
        
        [UIView animateWithDuration:0.8 animations:^{
            [_imgBack setHidden:NO];
            [_btnBack setHidden:NO];
            [_lblNavUsername setHidden:NO];
            [self.viewNav layoutIfNeeded];
        }];
    }else if(lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y < 250){
        self.constraintViewNavHeight.constant = 0.0f;
        [UIView animateWithDuration:0.5 animations:^{
            [_imgBack setHidden:YES];
            [_btnBack setHidden:YES];
            [_lblNavUsername setHidden:YES];
            [self.viewNav layoutIfNeeded];
        }];
    }

    
}

#pragma mark events
- (void)onBack:(id)sender {
    cntBtnBack ++;
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 0 && cntBtnBack == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == 1 && cntBtnBack == 1){
        [self.navigationController popViewControllerAnimated:YES];
    }

}


- (void)onBackTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onChatWithOtherUser:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        if (!isChat) {
            isChat = YES;
            RecentView *recentView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentView"];
            [self.navigationController pushViewController:recentView animated:YES];
        }
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }

}
- (IBAction)onUserFollowerTapped:(id)sender headerView:(OtherArtistProfileHeader *)headerView{

    if ([TattooUtilis isReallyUser]) {
        if (!isFolllow) {
            isFolllow = YES;
            if (![artistModelProfil isEqual:nil]) {
                [SharedModel instance].isArtistFollowed = YES;
                [SharedModel instance].isCheckedFollow = NO;
                [self onUserFollowWithUserID:artistModelProfil];
                [_collectionFeed reloadData];
            }
            
        }
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
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
    NSMutableArray *arrTattooIDs = [NSMutableArray array];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageDic = @{FOLLOW_ID:[FIRAuth auth].currentUser.uid,
                                 @"Time":time,
                                 @"CommentText":@"",
                                 @"NotificationStatus":[NSNumber numberWithInt:IS_FOLLOW_NOTIFICATION],
                                 @"ArrayTattoos":arrTattooIDs
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:userName];
}
- (void)onUserUnFollowWithUserID:(NSString *)userID{
    [[[[mainRef child:USER_FOLLOW_TABLE] queryOrderedByChild:FOLLOW_ID] queryEqualToValue:userID] observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        if (snapshot.exists && ![SharedModel instance].isArtistFollowed) {
            [SharedModel instance].isArtistFollowed = YES;
            [[[mainRef child:USER_FOLLOW_TABLE] child:[[snapshot value] allKeys].lastObject] setValue:nil];
        }
    }];
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
#pragma mark onVisit user profile
- (void)onVisitUserProfile:(id)sender event:(id)event {
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_collectionFeed];
    NSIndexPath *indexPath = [_collectionFeed indexPathForItemAtPoint: currentTouchPosition];
    TattooModel *tempTattooModel = arrSortedTattooModel[indexPath.row];
    if ([tempTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
        artistProfileVC.artistProfil_ID = tempTattooModel.user_id;
        [self.navigationController pushViewController:artistProfileVC animated:YES];
    }else{
        [FireBaseApiService onGetUserInfoFromFireBase:tempTattooModel.user_id withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
            if (userModel != nil) {
                artistModelProfil = userModel;
                [_collectionFeed reloadData];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    
}
#pragma mark Click Cell Post ICON
- (void)onPostTattoo:(id)sender event:(id)event {
    if ([TattooUtilis isReallyUser]) {
        NSSet *touches = [event allTouches];
        
        UITouch *touch = [touches anyObject];
        
        CGPoint currentTouchPosition = [touch locationInView:_collectionFeed];
        NSIndexPath *indexPath = [_collectionFeed indexPathForItemAtPoint: currentTouchPosition];
        TattooModel *temTattoModel =  arrSortedTattooModel[indexPath.row];
        if (temTattoModel.like_flag.intValue == 0)
        {
            temTattoModel.like_flag = [NSNumber numberWithInt:1];
            [self onAddFavorTattoo:mainRef withTattooModel:temTattoModel];
            [_collectionFeed reloadData];
            if (![temTattoModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
                [FireBaseApiService onGetRegistrationToken:temTattoModel.user_id withCompletion:^(TokenModel *tokenModel) {
                    if (tokenModel != nil && tokenModel.regist_token != nil) {
                        [self sendPushNotificationWithLike:tokenModel.regist_token withTattooID:temTattoModel.tattoo_id];
                        
                    }
                }];
            }
       }else{
            temTattoModel.like_flag = [NSNumber numberWithInt:0];
            [self onRemoveFavorStyleTable:mainRef withStyleModel:temTattoModel];
            [_collectionFeed reloadData];
       }

    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
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
                                 @"ArrayTattoos":arrTattooIDs
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:[FIRAuth auth].currentUser.displayName];
}
@end
