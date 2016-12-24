//
//  ProfileSettingViewController.m
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "ProfileSettingViewController.h"


@interface ProfileSettingViewController ()
{
    NSString *strTableName;
    BOOL isUpdatedInfo;
}

@end

@implementation ProfileSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    isUpdatedInfo = NO;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if ([SharedModel instance].isNotificaitonPermissioned) {
        [_switchPushNotification setOn:YES];
        
    }else{
        [_switchPushNotification setOn:NO];
    }

    _userDict = [NSDictionary dictionaryWithDictionary:[TattooUtilis getUserModel]];
    dispatch_async(dispatch_get_main_queue(), ^{
                [self initCustomUI:_userDict];
    });
    strTableName = USER_TABLE;
    
 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark InitCustomUI
- (void) initCustomUI:(NSDictionary *)userDic{
    _viewMask.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _viewMask.layer.cornerRadius=_viewMask.frame.size.width/2;
    _viewMask.clipsToBounds = YES;
    _imgUserPIC.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _imgUserPIC.layer.cornerRadius=_imgUserPIC.frame.size.width/2;
    _imgUserPIC.clipsToBounds = YES;

    [_imgUserPIC sd_setImageWithURL:userDic[USER_PHOTO_URL] placeholderImage:[UIImage imageNamed:@"no_photo"]];
    _lblNickName.text = userDic[USER_NAME];
    if (userDic[USER_PROVIDER_INSID] != nil)
    {
        _lblInsConnect.text = @"Connected with Instagram";
    }
        
}

- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onSelectArtist:(id)sender {
    
}
- (IBAction)onConnectFB:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/"]];
}
- (IBAction)onCameraOpen:(id)sender {
    [self openCamera];
}

- (IBAction)onConnectTW:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/"]];
}
- (IBAction)onSettingEmailNotification:(id)sender {
}
- (IBAction)onSettingPushNotification:(id)sender {
    if ([sender isOn]) {
        [SharedModel instance].isNotificaitonPermissioned = YES;
    }else{
        [SharedModel instance].isNotificaitonPermissioned = NO;
    }
}
- (IBAction)onRegister:(id)sender {
    if (isUpdatedInfo){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self imageUpload:self.imgUserPIC.image withTableName:strTableName withUserID:[FIRAuth auth].currentUser.uid withCompletion:^(NSURL *downLoadURL) {
            if ([strTableName isEqualToString:USER_TABLE]) {
                [TattooUtilis removeModel:USER_MODEL];
                isUpdatedInfo = NO;
                [self onUpdateUserPhoto:_userDict withImageURL:downLoadURL];
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
                isUpdatedInfo = NO;
                [TattooUtilis removeModel:TATTOOIST_MODEL];
                [self onUpdateTattoistPhoto:_userDict withImageURL:downLoadURL];
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
#pragma mark imagePickerViewController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *selecetdImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (selecetdImage != nil)
    {
        isUpdatedInfo = YES;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            self.imgUserPIC.image = selecetdImage;
            self.imgUserPIC.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        }];
    });
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
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
    
}

- (void)deleteUserModelFromFireBase:(NSString *)userID withTableName:(NSString *)tableName withCompletion:(void(^)(BOOL sucessflag))completion
{

                [[[[mainRef child:tableName] child:userID] child:USER_PHOTO_URL ] setValue:nil];
                [TattooUtilis sharedInstance].delete_sucess = 1;
                completion(true);
}

@end
