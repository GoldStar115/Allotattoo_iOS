//
//  ArtistSearchViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "ArtistSearchViewController.h"


@interface ArtistSearchViewController ()
{
    NSString *strUserID;
    NSString *strUserName;
    BOOL isChecked;
    BOOL isFiltered;
    BOOL isUserFollow;
    NSMutableArray *arraySendNoti;
    NSMutableArray *arrayCheck;
    NSMutableArray *arraySearchResult;
}
@end

@implementation ArtistSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _txtSearch.delegate = self;
    [self initSearchTextfiled];
    arraySendNoti = [NSMutableArray array];
    arrayCheck = [NSMutableArray array];
    arraySearchResult = [NSMutableArray array];
    _arrArtistUserModel= [NSMutableArray array];
    
    isChecked = NO;
    isFiltered = NO;
    isUserFollow = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FireBaseApiService onGetUserArrayFromFireBase:nil withTableName:USER_TABLE withCompletion:^(NSMutableArray *arrUserModel) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SharedModel instance].arrSharedUserModels  =arrUserModel;
        for (UserModel *userModel in [SharedModel instance].arrSharedUserModels) {
            if (userModel.tattooist_flag.intValue == 1) {
                [_arrArtistUserModel addObject:userModel];
                [arrayCheck addObject:@"uncheck"];
                [arraySendNoti addObject:[NSNumber numberWithInt:0]];
                [_tblArtistList reloadData];
            }
        }

    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];


    
}
- (void)initSearchTextfiled{
    _viewSearch.layer.cornerRadius = _viewSearch.frame.size.height/2;
    _txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Rechercher" attributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    


   

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewData Source

-  (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isFiltered) {
        return  arraySearchResult.count;
    }else{
        return _arrArtistUserModel.count;
    }
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArtistTableCell *artistCell = (ArtistTableCell *)[tableView dequeueReusableCellWithIdentifier:@"ArtistTableCell"];
    UserModel *userModel = [[UserModel alloc] init];
    if (isFiltered) {
        userModel = arraySearchResult[indexPath.row];
    }else{
        userModel = _arrArtistUserModel[indexPath.row];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        artistCell.imgArtistPIC.layer.cornerRadius = artistCell.imgArtistPIC.frame.size.width/2;
        artistCell.imgArtistPIC.clipsToBounds  = YES;
       
        [artistCell.imgArtistPIC  sd_setImageWithURL:userModel.user_photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
        artistCell.lblArtistName.text = userModel.user_Name;
    });
    if ([[arrayCheck objectAtIndex:indexPath.row] isEqualToString:@"uncheck"]) {
         [artistCell.btnCheck setBackgroundImage:[UIImage imageNamed:@"imgPlus"] forState:UIControlStateNormal];
    }else{
         [artistCell.btnCheck setBackgroundImage:[UIImage imageNamed:@"imgCheckCircle"] forState:UIControlStateNormal];
    }
    [artistCell.btnCheck addTarget:self action:@selector(onCheckValid:event:) forControlEvents:UIControlEventAllEvents];
    return artistCell;
}

#pragma mark delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserModel *userModel;
    if (isFiltered) {
        userModel = arraySearchResult[indexPath.row];
    }else{
        userModel = _arrArtistUserModel[indexPath.row];
    }
    ArtistProfileViewController *artistProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistProfileViewController"];
    OtherArtistProfileViewController *otherArtistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherArtistProfileViewController"];
    if ([userModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        artistProfileVC.artistProfil_ID = userModel.user_id;
        [self.navigationController pushViewController:artistProfileVC animated:YES];
    }else{
        otherArtistVC.artistProfil_ID = userModel.user_id;
        [self.navigationController pushViewController:otherArtistVC animated:YES];
    }


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76;
}
#pragma mark onBack
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark onCheckValid
- (void) onCheckValid:(id)sender event:(id)event{
    [self.viewValid setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:_tblArtistList];NSIndexPath *indexPath = [_tblArtistList indexPathForRowAtPoint: currentTouchPosition];
    ArtistTableCell *artistCell = (ArtistTableCell *)[_tblArtistList cellForRowAtIndexPath:indexPath];
    UserModel *tempUserModel = [[UserModel alloc] init];
    if(isFiltered){
        tempUserModel = arraySearchResult[indexPath.row];
    }else{
        tempUserModel = _arrArtistUserModel[indexPath.row];
    }
    if ([[arrayCheck objectAtIndex:indexPath.row] isEqualToString:@"uncheck"]) {
        [artistCell.btnCheck setBackgroundImage:[UIImage imageNamed:@"imgCheckCircle"] forState:UIControlStateNormal];
        if (![tempUserModel isEqual:nil]) {
            [SharedModel instance].isArtistFollowed = YES;
            [SharedModel instance].isCheckedFollow = NO;
            NSNumber *num = arraySendNoti[indexPath.row];
            if (num.intValue == 0) {
                [arraySendNoti replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:1]];
                [self onUserFollowWithUserID:tempUserModel];
            }
        }
        strUserID = tempUserModel.user_id;
        strUserName = tempUserModel.user_Name;
        for (int i = 0 ;  i < arrayCheck.count;  i ++) {
            if (i == (int)indexPath.row) {
                [arrayCheck replaceObjectAtIndex:i withObject:@"check"];
            }else{
                [arrayCheck replaceObjectAtIndex:i withObject:@"uncheck"];
            }
            
        }
    }else{
        [artistCell.btnCheck setBackgroundImage:[UIImage imageNamed:@"imgPlus"] forState:UIControlStateNormal];
        [arrayCheck replaceObjectAtIndex:indexPath.row withObject:@"uncheck"];
        [SharedModel instance].isArtistFollowed = NO;
        [SharedModel instance].isCheckedFollow = YES;
        [self onUserUnFollowWithUserID:tempUserModel.user_id];
    }
    [_tblArtistList reloadData];
}
- (IBAction)btnInviteArtist:(id)sender {
}
- (IBAction)onValid:(id)sender {

    if (![strUserID isEqualToString:@""]) {
        [SharedModel instance].postTattooModel.tattoist_ID = strUserID;
        [SharedModel instance].postContentModel.artist_name = strUserName;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UserFollower
- (void)onUserFollowWithUserID:(UserModel *)userModel{
    NSDictionary *userFollowDic = @{FOLLOW_ID:userModel.user_id,
                                    USER_ID:[FIRAuth auth].currentUser.uid,
                                    FOLLOW_PHOTO_URL:userModel.user_photoURL.absoluteString
                                    };
    [[[mainRef child:USER_FOLLOW_TABLE] childByAutoId] setValue:userFollowDic];
    [mainRef removeAllObservers];
    if (![userModel.user_id isEqualToString:[FIRAuth auth].currentUser.uid]) {
        [FireBaseApiService onGetRegistrationToken:userModel.user_id withCompletion:^(TokenModel *tokenModel) {
            if (tokenModel != nil && tokenModel.regist_token != nil) {
                [self sendPushNotificationWithFollow:tokenModel.regist_token withUserName:userModel.user_Name];
            }
        }];
    }

}
- (void)sendPushNotificationWithFollow:(NSString *)registToken withUserName:(NSString *)userName{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
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
        if (snapshot.exists && ![SharedModel instance].isArtistFollowed) {
            [SharedModel instance].isArtistFollowed = YES;
            [[[mainRef child:USER_FOLLOW_TABLE] child:[[snapshot value] allKeys].lastObject] setValue:nil];
        }
    }];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (IBAction)txtEditChanged:(id)sender {
    UITextField *txtField = (UITextField *)sender;
    [arraySearchResult removeAllObjects];
    if (txtField.text.length == 0) {
        isFiltered = NO;
    }else{
        isFiltered = YES;
        for (UserModel *userModel in _arrArtistUserModel) {
            NSString *username = userModel.user_Name;
            if([username rangeOfString:txtField.text].location != NSNotFound){
                [arraySearchResult addObject:userModel];
            }
        }
        
        
    }
    [_tblArtistList reloadData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _txtSearch.text = @"";
    [_btnSearchDismiss setHidden:NO];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self failedAlertAction:@"Votre tatoueur n'est pas référencé"];
    textField.text = @"";
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)btnSearchDismiss:(id)sender {
    _txtSearch.text = @"";
}

@end
