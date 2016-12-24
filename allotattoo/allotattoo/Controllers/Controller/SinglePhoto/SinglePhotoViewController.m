//
//  SinglePhotoViewController.m
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "SinglePhotoViewController.h"
#import "UserProfileViewController.h"
#import <RESideMenu.h>
#import "ArtistProfileViewController.h"
#import "ArtistSearchViewController.h"


@interface SinglePhotoViewController ()
{
    UserModel *singleUserModel;
    NSDictionary *userDic;
    BOOL isLoadedComment;
    NSMutableArray *arrCommentModel;
    NSMutableArray *arrayFavorTattooWithTattooID;

    NSString *sTitle;
    NSString *sDesciption;
    NSString *sContent;
    NSString *sURL;
    NSMutableArray *shareListArray;
    BOOL enableFacebook, enableTwitter, enableInstagram;
    AAShareBubbles *shareBubbles;
    UIImage *socialPostImage;
}
@property (nonatomic, strong) MGInstagram *instagram;
@end

@implementation SinglePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.instagram = [MGInstagram new];
    singleUserModel = [[UserModel alloc] init];
    arrayFavorTattooWithTattooID = [NSMutableArray array];
    userDic = [[NSDictionary alloc] init];
    arrCommentModel = [NSMutableArray array];
    [self.navigationController setNavigationBarHidden:YES];
    isLoadedComment = NO;
    
    _viewComment.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewComment.layer.borderWidth = 0.5f;
    
    _tblCommitContent.estimatedRowHeight = 150.0f;
    _tblCommitContent.rowHeight = UITableViewAutomaticDimension;
    [MBProgressHUD showHUDAddedTo:self.tblCommitContent animated:YES];
    for (UserModel *userModel in [SharedModel instance].arrSharedUserModels) {
        if ([userModel.user_id isEqualToString:_singleTattooModel.user_id]) {
            [arrCommentModel addObject:userModel];
            singleUserModel = userModel;
            break;
        }
    }
    [FireBaseApiService onGetCommentCount:_singleTattooModel.tattoo_id withCompletion:^(NSMutableArray *arrComment) {
        
                if (arrComment.count > 0){
                    [SharedModel instance].isLoadedComment = YES;
                    [arrCommentModel addObjectsFromArray:arrComment];
                    [_tblCommitContent reloadData];
                 
                }

    }];
    [FireBaseApiService onGetFavorTattooFromWithTattooIDFireBase:_singleTattooModel.tattoo_id withQuery:nil withCompleteion:^(NSMutableArray *arrFavorTattooWithTattooID) {
        [MBProgressHUD hideHUDForView:self.tblCommitContent animated:YES];
        if (arrFavorTattooWithTattooID.count > 0) {
            [SharedModel instance].isLoadedLike = YES;
            [arrayFavorTattooWithTattooID addObjectsFromArray:arrFavorTattooWithTattooID];
            [_tblCommitContent reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.tblCommitContent animated:YES];
    }];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

  

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [SharedModel instance].isLoadedComment = NO;
}
- (void)initCustomHeaderCellUI:(UserModel *)userModel withHeaderView:(SingleTattooHeaderCell *)headerCell{
    [headerCell.imgArtistPic sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
    headerCell.lblArtistName.text = userModel.user_Name ? userModel.user_Name : @"NIcolas Stouls";
    headerCell.lblArtistCommitTime.text = userModel.createdAt ? userModel.createdAt : @"il y 2 semaines";
    [headerCell.imgSinglePhoto sd_setImageWithURL:[NSURL URLWithString:_singleTattooModel.tattoo_image_url] placeholderImage:[UIImage imageNamed:@"imgSinglePhotoHolder"]];
    if (arrayFavorTattooWithTattooID.count > 0) {
        for (NSString *strLikeUserID in arrayFavorTattooWithTattooID) {
            if ([strLikeUserID isEqualToString:[FIRAuth auth].currentUser.uid]) {
                headerCell.imgLike.image = [UIImage imageNamed:@"btnlike"];
                _singleTattooModel.like_flag = [NSNumber numberWithInt:1];
            }else{
                headerCell.imgLike.image = [UIImage imageNamed:@"btndislike"];
                _singleTattooModel.like_flag = [NSNumber numberWithInt:0];
            }
        }
    }else{
        headerCell.imgLike.image = [UIImage imageNamed:@"btndislike"];
        _singleTattooModel.like_flag = [NSNumber numberWithInt:0];
    }
    socialPostImage = headerCell.imgSinglePhoto.image;
    headerCell.lblLikeNumber.text = [NSString stringWithFormat:@"%d",(int)arrayFavorTattooWithTattooID.count];
    if (_singleTattooModel.tattoist_ID == nil || [_singleTattooModel.tattoist_ID isEqualToString:@""]) {
        [headerCell.btnTattoistProfile setHidden:YES];
    }
    headerCell.lblCommitNumber.text = [NSString stringWithFormat:@"%d",(int)arrCommentModel.count - 1];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UItableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (arrCommentModel.count > 0) {
      return  arrCommentModel.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingleTattooHeaderCell *headerCell = (SingleTattooHeaderCell *)[tableView dequeueReusableCellWithIdentifier:@"SingleTattooHeaderCell"];
    SinglePhotoCommitCell *singlePhotoCell = (SinglePhotoCommitCell *)[tableView dequeueReusableCellWithIdentifier:@"SinglePhotoCommitCell"];
    if (indexPath.row == 0) {
        [self initCustomHeaderCellUI:arrCommentModel[indexPath.row] withHeaderView:headerCell];
        
        [headerCell.btnLike addTarget:self action:@selector(onPostTattoo:event:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell.btnShare addTarget:self action:@selector(onShareTatto:) forControlEvents:UIControlEventTouchUpInside];
        [headerCell.btnTattoistProfile addTarget:self action:@selector(onTattoistProfile:) forControlEvents:UIControlEventTouchUpInside];
        
        return headerCell;
    }else{
        singlePhotoCell.imgUserPic.layer.cornerRadius = singlePhotoCell.imgUserPic.frame.size.width/2;
        singlePhotoCell.imgUserPic.clipsToBounds = YES;
        CommentModel *commentModel = arrCommentModel[indexPath.row];
        UserModel *userModel;
        for (UserModel *commentUserModel in [SharedModel instance].arrSharedUserModels)
        {
            if ([commentModel.user_id isEqualToString:commentUserModel.user_id]) {
                userModel = commentUserModel;
                break;
            }
        }
        [singlePhotoCell.imgUserPic sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
        singlePhotoCell.lblCommitName.text = commentModel.user_Name;
        singlePhotoCell.labDate.text = commentModel.createdAt;
        singlePhotoCell.lblCommitContent.text = commentModel.comment_content;
        return singlePhotoCell;
    }

}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.row  > 0) {
//        CommentModel *commentModel = arrCommentModel[indexPath.row];
//        UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
//        OtherUserProfileViewController *otherUserProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherUserProfileViewController"];
//        if ([commentModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
//            userProfileVC.userProfil_ID = commentModel.user_id;
//            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:userProfileVC] animated:YES];
//            [self.sideMenuViewController hideMenuViewController];
//        }else{
//            otherUserProfileVC.userProfil_ID = commentModel.user_id;
//            [self.navigationController pushViewController:otherUserProfileVC animated:YES];
//        }
//    }


}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 520.0f;
    }else{
        return UITableViewAutomaticDimension;
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark onBack
- (IBAction)onBack:(id)sender {
//    [SharedModel instance].feedIndex = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark Visit TattooistProfile
- (IBAction)onTattoistProfile:(id)sender {
        ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
        OtherArtistProfileViewController *otherArtistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherArtistProfileViewController"];
    NSLog(@"SingleTattoo %@",_singleTattooModel);
        if ([_singleTattooModel.tattoist_ID isEqualToString:[FIRAuth auth].currentUser.uid]) {
            artistProfileVC.artistProfil_ID = _singleTattooModel.tattoist_ID;
            [self.navigationController pushViewController:artistProfileVC animated:YES];
        }else{
            otherArtistVC.artistProfil_ID = _singleTattooModel.tattoist_ID;
            [self.navigationController pushViewController:otherArtistVC animated:YES];
        }

}

#pragma mark Social Post
- (IBAction)onShareTatto:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        if(shareBubbles) {
            shareBubbles = nil;
        }
        shareBubbles = [[AAShareBubbles alloc] initWithPoint:self.view.center radius:100 inView:self.view];
        shareBubbles.delegate = self;
        shareBubbles.bubbleRadius = 30;
        shareBubbles.showFacebookBubble = YES;
        shareBubbles.showInstagramBubble = YES;
        [shareBubbles show];
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }
  


}
#pragma mark AAShareBubbleDelegate
- (void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{

    switch (bubbleType) {
        case AAShareBubbleTypeFacebook:
            [self facebookShare:nil];
            break;
        case AAShareBubbleTypeInstagram:
            [self postInstagramImage:[self postMergeImage:socialPostImage]];
            break;
        default:
            break;
    }
}
- (void)aaShareBubblesDidHide:(AAShareBubbles *)shareBubbles
{
    
}
#pragma mark faceBook Share
- (void)facebookShare:(UIImage *)image{
    
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = [self postMergeImage:socialPostImage];
    photo.userGenerated = NO;
    FBSDKSharePhotoContent *contentPhoto = [[FBSDKSharePhotoContent alloc] init];
    contentPhoto.photos = @[photo];
    [FBSDKShareDialog showFromViewController:self withContent:contentPhoto delegate:nil];
}
- (void) postInstagramImage:(UIImage*) image {
    NSLog(@"%f,%f",image.size.width,image.size.height);
    if ( [MGInstagram isImageCorrectSize:image] && [MGInstagram isAppInstalled]) {
        [self.instagram postImage:image inView:self.view];
    }
    else {
        [self failedAlertAction:@"Instagram must be installed on the device in order to post images"];
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

#pragma mark Visit list of users who like photos
- (IBAction)onFavorTattoo:(id)sender {
        ArtistSearchViewController * artistSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistSearchViewController"];
        if (arrayFavorTattooWithTattooID.count > 0) {
                artistSearchVC.arrLikeTattoos = [NSMutableArray array];
                artistSearchVC.arrLikeTattoos = arrayFavorTattooWithTattooID;
        }
        artistSearchVC.likeTattooID = _singleTattooModel.tattoo_id;
    [self.navigationController pushViewController:artistSearchVC animated:YES];
    
}
#pragma mark Comment
- (IBAction)onComment:(id)sender {
    if ([TattooUtilis isReallyUser]) {
            [CLGCommentInputViewController showInViewController:self title:nil sendTitle:@"Envoyer" cancelTitle:nil delegate:(id<CLGCommentInputViewControllerDelegate>)self];
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }

}
#pragma mark CLGCommentInputViewControllerDelegate
- (void)didClickSendButton:(CLGCommentInputViewController *)commentInputVC sendText:(NSString *)commenttext
{
    [_viewComment setHidden:NO];
    CommentModel *commentModel = [self convertDicToCommentModel:[self onComment:[TattooUtilis getUserModel] withTattooID:_singleTattooModel.tattoo_id withContent:commenttext]];
    [arrCommentModel addObject:commentModel];
    
    [SharedModel instance].isLoadedComment = YES;
    [_tblCommitContent reloadData];
    [commentInputVC hideKeyboard];
    [commentInputVC dismissViewControllerAnimated:YES completion:nil];
    if (![_singleTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        [FireBaseApiService onGetRegistrationToken:_singleTattooModel.user_id withCompletion:^(TokenModel *tokenModel) {
            if (tokenModel != nil && tokenModel.regist_token != nil) {
                [self sendPushNotificationWithComment:tokenModel.regist_token withCommentText:commenttext];
            }
        }];
    }
    
}
- (NSDictionary *)onComment:(NSDictionary *)userCommentDic withTattooID:(NSString *)tattooID withContent:(NSString*)commentText
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    ;
    NSDictionary *commentDic = @{USER_ID:userCommentDic[USER_ID],
                                 USER_NAME:userCommentDic[USER_NAME],
                                 USER_PHOTO_URL:userCommentDic[USER_PHOTO_URL],
                                 CREATE_AT:[formatter stringFromDate:[NSDate date]],
                                 COMMENT_CONTENT:commentText
                                 };
    [[[[mainRef child:COMMENT_TABLE] child:tattooID] childByAutoId] setValue:commentDic];
    return commentDic;
}
#pragma mark send push message with Topic
- (void)sendPushNotificationWithComment:(NSString *)registToken withCommentText:(NSString *)commentText{
//    NSMutableArray *arrTattooIDs = [NSMutableArray array];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageDic = @{FOLLOW_ID:[FIRAuth auth].currentUser.uid,
                                 @"Time":time,
                                 @"CommentText":commentText,
                                 @"NotificationStatus":[NSNumber numberWithInt:IS_COMMENT_NOTIFICATION],
                                 @"ArrayTattoos":_singleTattooModel.tattoo_id
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:[FIRAuth auth].currentUser.displayName];
}
- (CommentModel *)convertDicToCommentModel:(NSDictionary *)dictionary
{
    CommentModel *commentModel = [[CommentModel alloc] initWithDictionary:dictionary error:nil];
    return commentModel;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark Click Cell Post ICON
- (void)onPostTattoo:(id)sender event:(id)event {
    if ([TattooUtilis isReallyUser]) {
        [SharedModel instance].isLoadedLike = YES;
        if (_singleTattooModel.like_flag.intValue == 0)
        {
            _singleTattooModel.like_flag = [NSNumber numberWithInt:1];
            
            [arrayFavorTattooWithTattooID addObject:[FIRAuth auth].currentUser.uid];
            [self onAddFavorTattoo:mainRef withTattooModel:_singleTattooModel];
            [_tblCommitContent reloadData];
            if (![_singleTattooModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
                [FireBaseApiService onGetRegistrationToken:_singleTattooModel.user_id withCompletion:^(TokenModel *tokenModel) {
                    if (tokenModel != nil && tokenModel.regist_token != nil) {
                        [self sendPushNotificationWithLike:tokenModel.regist_token withTattooID:_singleTattooModel.tattoo_id];
                    }
                }];
            }
        }else{
            _singleTattooModel.like_flag = [NSNumber numberWithInt:0];
            [arrayFavorTattooWithTattooID removeLastObject];
            [self onRemoveFavorStyleTable:mainRef withStyleModel:_singleTattooModel];
            [_tblCommitContent reloadData];
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
#pragma mark send push message with Topic
- (void)sendPushNotificationWithLike:(NSString *)registToken withTattooID:(NSString *)tattooID{
    NSMutableArray *arrTattooIDs = [NSMutableArray array];
    [arrTattooIDs addObject:tattooID];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    NSDictionary *messageDic = @{FOLLOW_ID:[FIRAuth auth].currentUser.uid,
                                 @"Time":time,
                                 @"CommentText":@"",
                                 @"NotificationStatus":[NSNumber numberWithInt:IS_LIKE_NOTIFICATION],
                                 @"ArrayTattoos":tattooID
                                 };
    [TattooUtilis sendPushNotificationWithFollowUserID:registToken withMessageContent:messageDic withUserName:[FIRAuth auth].currentUser.displayName];
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
#pragma mark ImageMerge
-(UIImage *)postMergeImage :(UIImage *)image
{
    UIView *mergeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
    UIImageView *imgBackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 640, 640)];
    imgBackView.image = image;
    [mergeView addSubview:imgBackView];
    
    UIImageView *imageLogoView = [[UIImageView alloc] initWithFrame:CGRectMake(512, 600, 115, 24)];
    imageLogoView.image = [UIImage imageNamed:@"imgLogo"];
    [mergeView addSubview:imageLogoView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(364, 605, 153, 22)];
    label.text = @"Publié avec l’app";
    [label setFont:[UIFont systemFontOfSize:19.0f]];
    [label setTextColor:[UIColor whiteColor]];
    [mergeView addSubview:label];
    
    
    UIGraphicsBeginImageContext(mergeView.bounds.size);
    [mergeView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  finalImage;
}
@end
