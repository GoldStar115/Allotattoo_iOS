//
//  WishListViewController.m
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "WishListViewController.h"
#import "MesFavorisViewController.h"
#import <RESideMenu.h>
#import "PhotoFeedViewController.h"
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKAccessToken.h>
#import <MBProgressHUD.h>

@interface WishListViewController ()

@end

@implementation WishListViewController

- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    if (_loginedFlag == YES) {
        [_btnQU setHidden:YES];
        [_btnConnectFB setHidden: YES];
        [_btnConnectWithIns setHidden:YES];
        [_btnWishList setHidden: YES];
        _lblWishDes.text = @"";
    }else{
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onMyWIshList:(id)sender {
    MesFavorisViewController *mesFavorisVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MesFavorisViewController"];
    [self presentViewController:mesFavorisVC animated:YES completion:nil];
}

- (IBAction)onConnectINS:(id)sender {
    
}
- (IBAction)onConnectFB:(id)sender {
    [self onFaceBookLogin];    
}
- (IBAction)onBack:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:NO];
    [self.sideMenuViewController hideMenuViewController];
    
}
#pragma mark FaceBook Login Modul
- (void) onFaceBookLogin{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    MenuViewController *menuView = [[MenuViewController alloc] init];
    FBSDKLoginManager * logIn = [[FBSDKLoginManager alloc] init];
    [logIn logInWithReadPermissions:@[@"public_profile", @"email", @"user_location", @"user_photos",@"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result , NSError *error){
        
        if (error) {
            NSLog(@"Process error");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [menuView onLogoutEngine];
            
        }else if (result.isCancelled){
            NSLog(@"Cancelled");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [menuView onLogoutEngine];
        } else{
            if ([FBSDKAccessToken currentAccessToken]) {
                [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"picture.type(large), email, name, id, gender,age_range,birthday,location"}]
                 startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                     
                     if (!error) {
                         ////////Login FaceBook +FireBase////////
                         FIRAuthCredential *credential = [FIRFacebookAuthProvider
                                                          credentialWithAccessToken:[FBSDKAccessToken currentAccessToken]
                                                          .tokenString];
                         [[FIRAuth auth] signInWithCredential:credential
                                                   completion:^(FIRUser *user, NSError *error) {
                                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                       if (error == nil) {
                                                           [FireBaseApiService onGetUserInfoFromFireBase:[FIRAuth auth].currentUser.uid withTableName:USER_TABLE withCompletion:^(UserModel *userModel) {
                                                               if (userModel != nil) {
                                                                   [TattooUtilis saveIsKindUsers:[NSNumber numberWithInt:isKindTattooUser]];
                                                                   [self onCreateUserTableToUserDefault:userModel];
                                                                   [self onSuccessLogin];
                                                               }else{
                                                                   [self userInitWithFireBaseUser:user withResult:result];
                                                                   [self onSuccessLogin];
                                                                   [self onCreateUserTableToFireBase:[UserModel instance]];
                                                                   [self onCreateUserTableToFireBase:[UserModel instance]];
                                                                   
                                                               }
                                                               [FUser signInWithCredential:credential completion:^(FUser * _Nonnull user, NSError * _Nonnull error) {
                                                                   if (user != nil){
                                                                       UserLoggedIn(LOGIN_FACEBOOK);
                                                                   }
                                                               }];
                                                           } failure:^(NSError *error) {
                                                               NSLog(@"Error %@",error);
                                                           }];
                                                           
                                                           
                                                       }else{
                                                           NSLog(@"Error %@",error);
                                                           [menuView onLogoutEngine];
                                                       }
                                                       
                                                   }];
                     }
                 }];
                
            }
        }
    }];
}

#pragma mark Enter without Login
- (IBAction)onEnterWithoutLogin:(id)sender {
    [[FIRAuth auth] signInWithEmail:@"no_user@test.com" password:@"sec12345" completion:^(FIRUser * _Nullable user, NSError * _Nullable error) {
        if (error == nil) {
            [self onSuccessLogin];
        }
    }];
}
#pragma mark Success Login
- (void)onSuccessLogin{
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [self.navigationController pushViewController:photoFeedVC animated:YES];
}
#pragma mark UserModel Init
- (void)userInitWithFireBaseUser:(FIRUser *)user withResult:(id)result{
    NSLog(@"RESULT = %@",result);
    NSDictionary *dicLocation = [result objectForKey:@"location"];
    [UserModel instance].user_provideFBID = [result objectForKey:@"id"];
    [UserModel instance].user_Name = user.displayName;
    [UserModel instance].user_id = user.uid;
    [UserModel instance].user_email = user.email;
    if (dicLocation != nil) {
        [UserModel instance].userLocation = [dicLocation objectForKey:@"name"] ? [dicLocation objectForKey:@"name"] :@"Paris";
    }else{
        [UserModel instance].userLocation = @"Paris";
    }
    [UserModel instance].user_photoURL = user.photoURL;
    [UserModel instance].userRefreshToken = user.refreshToken;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    [UserModel instance].createdAt  = [formatter stringFromDate:[NSDate date]];
    [UserModel instance].tattooshop_id = [NSString stringWithFormat:@"1"];
    [UserModel instance].provideINSID = @"";
}
#pragma mark UserModel Save to the FireBase
- (void)onCreateUserTableToFireBase:(UserModel *)userModel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSDictionary *user_table = @{
                                 USER_ID:userModel.user_id,
                                 USER_PROVIDER_FBID:userModel.user_provideFBID ? userModel.user_provideFBID:@"",
                                 USER_NAME:userModel.user_Name,
                                 USER_EMAIL:userModel.user_email,
                                 USER_PHOTO_URL:userModel.user_photoURL.absoluteString,
                                 USER_LOCATION:userModel.userLocation,
                                 USER_REFESHTOKEN:userModel.userRefreshToken,
                                 CREATE_AT:userModel.createdAt ? userModel.createdAt : [formatter stringFromDate:[NSDate date]],
                                 TATTOO_SHOP_ID:userModel.tattooshop_id ? userModel.tattooshop_id: @"1" ,
                                 USER_FLAG:[NSNumber numberWithInt:isKindTattooUser],
                                 USER_PROVIDER_INSID:userModel.provideINSID ? userModel.provideINSID :@""
                                 };
    //////////////UserModel Save To the NSUserDefault///////////////////////////////////////////////
    
    [[[mainRef child:USER_TABLE] child:userModel.user_id] setValue:user_table];
    
    
}
#pragma mark UserModel Save to the FireBase
- (void)onCreateUserTableToUserDefault:(UserModel *)userModel {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];
    NSDictionary *user_table = @{
                                 USER_ID:userModel.user_id,
                                 USER_PROVIDER_FBID:userModel.user_provideFBID ? userModel.user_provideFBID:@"",
                                 USER_NAME:userModel.user_Name,
                                 USER_EMAIL:userModel.user_email,
                                 USER_PHOTO_URL:userModel.user_photoURL.absoluteString,
                                 USER_LOCATION:userModel.userLocation,
                                 USER_REFESHTOKEN:userModel.userRefreshToken? userModel.userRefreshToken :[FIRAuth auth].currentUser.refreshToken,
                                 CREATE_AT:userModel.createdAt ? userModel.createdAt : [formatter stringFromDate:[NSDate date]],
                                 TATTOO_SHOP_ID:userModel.tattooshop_id ? userModel.tattooshop_id: @"1" ,
                                 USER_FLAG:userModel.user_flag ? userModel.user_flag : [NSNumber numberWithInt:isKindTattooUser],
                                 USER_PROVIDER_INSID:userModel.provideINSID ? userModel.provideINSID : @""
                                 };
    //////////////UserModel Save To the NSUserDefault///////////////////////////////////////////////
    [TattooUtilis saveUserModel:user_table];
    
}

@end
