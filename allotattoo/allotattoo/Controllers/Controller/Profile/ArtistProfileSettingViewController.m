//
//  ArtistProfileSettingViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "ArtistProfileSettingViewController.h"

@interface ArtistProfileSettingViewController ()
{
    NSString *strTableName;
    BOOL isUpdatedInfo;
}
@end

@implementation ArtistProfileSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _userDic = [[NSDictionary alloc] init];
    isUpdatedInfo = NO;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if ([SharedModel instance].isNotificaitonPermissioned) {
        [_switchPushNotiSetting setOn:YES];
    }else{
        [_switchPushNotiSetting setOn:NO];
    }
    ////userImage

    _userDic = [NSDictionary dictionaryWithDictionary:[TattooUtilis getUserModel]];
    strTableName = USER_TABLE;
    dispatch_async(dispatch_get_main_queue(), ^{
            [self initCustomUI:_userDic];
    });
    if ([_userDic[TATTOO_SHOP_ID] isEqualToString:@""] && _userDic[TATTOO_SHOP_ID] == nil){
        _lblTattooShopName.text = @"Please select tattoo shop.";
    }else{
        [FireBaseApiService onGetTattooShopInfoWithTattooShopID:_userDic[TATTOO_SHOP_ID] withCompletion:^(TattooShopModel *tattooShopModel) {
            dispatch_async(dispatch_get_main_queue(), ^{
                _lblTattooShopName.text = tattooShopModel.tattoo_shop_name;
            });
        }];
    }

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}
#pragma mark InitCustomUI
- (void) initCustomUI:(NSDictionary *)userDic{
    _viewMask.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _viewMask.layer.cornerRadius=_viewMask.frame.size.width/2;
    _viewMask.clipsToBounds = YES;
    _viewMask.layer.borderColor=[[UIColor redColor] CGColor];
    
    
    _userPic.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _userPic.layer.cornerRadius=_userPic.frame.size.width/2;
    _userPic.clipsToBounds = YES;
    _userPic.layer.borderColor=[[UIColor redColor] CGColor];
    [_userPic sd_setImageWithURL:userDic[USER_PHOTO_URL] placeholderImage:[UIImage imageNamed:@"no_photo"]];
    _lblArtistName.text = userDic[USER_NAME];
    if (userDic[USER_PROVIDER_INSID] != nil) {
        _lblConnectedIns.text = @"Connected with Instagram";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSelectArtist:(id)sender {
}

- (IBAction)onSelectTattooShop:(id)sender {
}

- (IBAction)onConnectWithFB:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/"]];
}
- (IBAction)onConnectWithTW:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/"]];
}
- (IBAction)onSettingPushNotification:(id)sender {
    if ([sender isOn]) {
        [SharedModel instance].isNotificaitonPermissioned = YES;
    }else{
        [SharedModel instance].isNotificaitonPermissioned = NO;
    }
}

- (IBAction)onSettingEmailNotification:(id)sender {
}

- (IBAction)onValier:(id)sender {
    if (!isUpdatedInfo) {
        return;
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self imageUpload:self.userPic.image withTableName:strTableName withUserID:[FIRAuth auth].currentUser.uid withCompletion:^(NSURL *downLoadURL) {
            
            if ([strTableName isEqualToString:USER_TABLE]) {
                [TattooUtilis removeModel:USER_MODEL];
                [self onUpdateUserPhoto:_userDic withImageURL:downLoadURL];
                isUpdatedInfo = NO;
                FIRUser *user = [FIRAuth auth].currentUser;
                FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
                changeRequest.photoURL = downLoadURL;
                [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        NSLog(@"SuccessUpdate");
                    }else{
                        
                    }
                }];
            }else{
                [TattooUtilis removeModel:TATTOOIST_MODEL];
                [self onUpdateTattoistPhoto:_userDic withImageURL:downLoadURL];
                isUpdatedInfo = NO;
                FIRUser *user = [FIRAuth auth].currentUser;
                FIRUserProfileChangeRequest *changeRequest = [user profileChangeRequest];
                changeRequest.photoURL = downLoadURL;
                [changeRequest commitChangesWithCompletion:^(NSError * _Nullable error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        NSLog(@"SuccessUpdate");
                    }else{
                        
                    }
                }];
            }
        }];
    }
}
- (void)updateDefaultUserProfile:(NSURL *)imageURL{

}
- (IBAction)onCapturePhoto:(id)sender {
    [self openCamera];
}
#pragma mark OpenCamera
- (void) openCamera
{
    [self openPhotoPicker:UIImagePickerControllerSourceTypeCamera];
}
- (void)openPhotoPicker:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
            imagePickerController.sourceType = sourceType;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            imagePickerController.delegate = self;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
}
#pragma mark ImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selecetdImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (selecetdImage !=  nil) {
        isUpdatedInfo = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            self.userPic.image = selecetdImage;
            self.userPic.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        }];
    });
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    isUpdatedInfo = NO;
}
- (void)imageUpload:(UIImage *)uploadImage withTableName:(NSString *)imageTatbleName withUserID:(NSString *)userID withCompletion:(void (^)(NSURL *downLoadURL))completion{
    
    FIRStorage *storage = [FIRStorage storage];
    NSString *uploadRef = [NSString stringWithFormat:@"gs://allotatto.appspot.com/%@/%@.png",imageTatbleName,userID];
    FIRStorageReference *storageRef = [storage referenceForURL:uploadRef];
    NSData *imageData = UIImagePNGRepresentation(uploadImage);
    [storageRef putData:imageData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        
        if (!error) {
            NSURL *downloadURL = metadata.downloadURL;
            completion(downloadURL);
            NSLog(@"DownLoad URL = %@",downloadURL);
        }else
        {
            NSLog(@"Error = %@",error);
        }
    }];
}
#pragma mark UserModel Save to the FireBase
- (void)onUpdateUserPhoto:(NSDictionary *)userDic withImageURL:(NSURL *)imageURL{
    
    NSDictionary *user_table = @{
                                 USER_ID:userDic[USER_ID],
                                 USER_PROVIDER_FBID:userDic[USER_PROVIDER_FBID],
                                 USER_NAME:userDic[USER_NAME],
                                 USER_EMAIL:userDic[USER_EMAIL],
                                 USER_PHOTO_URL:imageURL.absoluteString,
                                 USER_LOCATION:userDic[USER_LOCATION],
                                 USER_REFESHTOKEN:userDic[USER_REFESHTOKEN],
                                 CREATE_AT:userDic[CREATE_AT],
                                 USER_FLAG:[NSNumber numberWithInt:isKindTattooUser]
                                 };
    [TattooUtilis saveUserModel:user_table];
    [[[[mainRef  child:USER_TABLE] child:userDic[USER_ID]] child:USER_PHOTO_URL] setValue:imageURL.absoluteString];
    [self dismissViewControllerAnimated:YES completion:nil ];
    
}
- (void)onUpdateTattoistPhoto:(NSDictionary *)userDic withImageURL:(NSURL *)imageURL{
    NSDictionary *user_table = @{
                                 USER_ID:userDic[USER_ID],
                                 USER_PROVIDER_FBID:userDic[USER_PROVIDER_FBID],
                                 USER_NAME:userDic[USER_NAME],
                                 USER_EMAIL:userDic[USER_EMAIL],
                                 USER_PHOTO_URL:imageURL.absoluteString,
                                 USER_LOCATION:userDic[USER_LOCATION],
                                 USER_REFESHTOKEN:userDic[USER_REFESHTOKEN],
                                 CREATE_AT:userDic[CREATE_AT],
                                 USER_FLAG:[NSNumber numberWithInt:isKindTattooist]
                                 };
    
    //////////////TattooistModel Save To the NSDefaultUser///////////////////////////////////////////////
    [TattooUtilis saveTattooistModel:user_table];
    [[[[mainRef  child:USER_TABLE] child:userDic[USER_ID]] child:USER_PHOTO_URL] setValue:imageURL.absoluteString];
    [self dismissViewControllerAnimated:YES completion:nil ];
}

@end
