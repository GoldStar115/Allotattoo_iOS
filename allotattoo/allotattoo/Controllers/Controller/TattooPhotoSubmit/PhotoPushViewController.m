//
//  PhotoPushViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "PhotoPushViewController.h"
#import "PhotoStyleSelectViewController.h"
#import "SelectBodyAreaViewController.h"
#import "ArtistSearchViewController.h"
#import "SelectTattoShopViewController.h"
#import <MGInstagram.h>
@interface PhotoPushViewController ()<UINavigationControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    BOOL isSelectStyle;
    BOOL isSelectBody;
}
@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property (nonatomic, strong) MGInstagram *instagram;
@end

@implementation PhotoPushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_lblBodyObilg setHidden:YES];
    [_lblBodyChanger setHidden:YES];
    
    [_lblStyleOblig setHidden:YES];
    [_lblStyleChanger setHidden:YES];
    isSelectBody = NO;
    isSelectStyle = NO;

    self.instagram = [MGInstagram new];
    
     _shareTattooModel = [[TattooModel alloc] init];
    if (_imgCapture != nil) {
        _imgCapturedPhoto.image = _imgCapture;
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",[SharedModel instance].postTattooModel);
    NSLog(@"%@",[SharedModel instance].postContentModel);
    
    if ([SharedModel instance].postContentModel.artist_name != nil) {
        _lblArtistName.text = [SharedModel instance].postContentModel.artist_name;
    }
    else{
        _lblArtistName.text = @"Identifier un tatoueur";
    }
    if ([SharedModel instance].postContentModel.tattooshop_name !=nil) {
        _lblTattooShopName.text = [SharedModel instance].postContentModel.tattooshop_name;
    }
    else{
        _lblTattooShopName.text = @"Identifier un salon de tatouage";
    }
    if ([SharedModel instance].postContentModel.style_name != nil) {
        [_lblStyleChanger setHidden:NO];
        [_lblStyleOblig setHidden:YES];
        _lblSelectTattooStyle.text = [SharedModel instance].postContentModel.style_name;
    }else{
        [_lblStyleChanger setHidden:YES];
//        if (isSelectStyle) {
            [_lblStyleOblig setHidden:YES];
//        }
        _lblSelectTattooStyle.text = @"Sélectionner le(s) style(s) de tattoo";
    }
    if ([SharedModel instance].postContentModel.category_name != nil) {
        [_lblBodyChanger setHidden:NO];
        [_lblBodyObilg setHidden:YES];
        _lblTattooBody.text = [SharedModel instance].postContentModel.category_name;
    }else{
        [_lblBodyChanger setHidden:YES];
//        if (isSelectBody) {
            [_lblBodyObilg setHidden:YES];
//        }

        _lblTattooBody.text = @"Sélectionner une partie du corps";
    }
    if ([SharedModel instance].postTattooModel.style_id != nil && [SharedModel instance].postTattooModel.category_id != nil) {
        [_btnPublish setBackgroundColor:[UIColor colorWithRed:6.0f/255.0f green:190.0f/255.0f blue:189.0f/255.0f alpha:1.0f]];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSelectStyle:(id)sender {
    isSelectStyle = YES;
    PhotoStyleSelectViewController *photoStyleSelectorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoStyleSelectViewController"];
    [self.navigationController pushViewController:photoStyleSelectorVC animated:YES];
}

- (IBAction)onSelectBodyArea:(id)sender {
    isSelectBody = YES;
    SelectBodyAreaViewController *selectBodyAreaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectBodyAreaViewController"];
    [self.navigationController pushViewController:selectBodyAreaVC animated:YES];
}
- (IBAction)onSelectArtist:(id)sender {
    ArtistSearchViewController*artistSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ArtistSearchViewController"];
    [self.navigationController pushViewController:artistSearchVC animated:YES];
}
- (IBAction)onSelectTattoShop:(id)sender {
    SelectTattoShopViewController   *selectTattoShopVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectTattoShopViewController"];
    [self.navigationController pushViewController:selectTattoShopVC animated:YES];
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onPublish:(id)sender {
    if ([SharedModel instance].postTattooModel.style_id != nil && [SharedModel instance].postTattooModel.category_id != nil) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self imageUpload:self.imgCapturedPhoto.image withTableName:[SharedModel instance].postContentModel.style_name withUserID:nil withCompletion:^(NSURL *downLoadURL) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *postTattooDic = @{USER_ID:[FIRAuth auth].currentUser.uid,
                                            TATTOO_IMG_URL:downLoadURL.absoluteString,
                                            STYLE_ID:[SharedModel instance].postTattooModel.style_id,
                                            CATEGORY_ID:[SharedModel instance].postTattooModel.category_id,
                                            TATTOO_SHOP_ID:[SharedModel instance].postTattooModel.tattooShop_id ?  [SharedModel instance].postTattooModel.tattooShop_id : @"",
                                            TATTOO_LINK:@"https://www.facebook.com/",
                                            TATTOO_NAME:_txtViewDes.text,
                                            TATTOOIST_ID:[SharedModel instance].postTattooModel.tattoist_ID ? [SharedModel instance].postTattooModel.tattoist_ID :@""
                                            };
            [[[mainRef child:TATTOO_TABLE] childByAutoId] setValue:postTattooDic];
            [SharedModel instance].success_post = YES;
            [self successPost];
        }];
    }else if ([SharedModel instance].postTattooModel.style_id != nil && [SharedModel instance].postTattooModel.category_id == nil){
        [_lblBodyObilg setHidden:NO];
        [_lblStyleOblig setHidden:YES];
    }
    else if ([SharedModel instance].postTattooModel.style_id == nil && [SharedModel instance].postTattooModel.category_id != nil){
        [_lblBodyObilg setHidden:YES];
        [_lblStyleOblig setHidden:NO];
    }else{
        [_lblBodyObilg setHidden:NO];
        [_lblStyleOblig setHidden:NO];
    }
}

- (IBAction)onShareInstagram:(id)sender {
    [self postInstagramImage:[self postMergeImage:_imgCaptureInside]];
}
- (void)postInstagram:(UIImage *)image{
    NSString *fileImagePath = [NSString stringWithFormat:@"%@/image.igo",[NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) lastObject]];
    [[NSFileManager defaultManager] removeItemAtPath:fileImagePath error:nil];
    [UIImagePNGRepresentation(image) writeToFile:fileImagePath atomically:YES];
    _dic = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:fileImagePath]];
    _dic.delegate = self;
    _dic.UTI = @"com.instagram.exclusivegram";
    
    [_dic presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
    
}
- (void)documentInteractionControllerWillBeginPreview:(UIDocumentInteractionController *)controller
{
    NSLog(@"OK");
}
- (IBAction)onShareFaceBook:(id)sender {
    [self facebookShare:[self postMergeImage:_imgCaptureInside]];
}
#pragma mark Success Post
- (void)successPost {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
#pragma mark faceBook Share
- (void)facebookShare:(UIImage *)image{
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
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

- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
            break;
        case 0x42:
            return @"bmp";
        case 0x4D:
            return @"tiff";
    }
    return nil;
}
- (void)imageUpload:(UIImage *)uploadImage withTableName:(NSString *)imageTatbleName withUserID:(NSString *)userID withCompletion:(void (^)(NSURL *downLoadURL))completion{

    NSData *imageData = UIImageJPEGRepresentation(uploadImage, 0.7);
    FIRStorage *storage = [FIRStorage storage];
    NSString *uploadRef = @"gs://allotatto.appspot.com";
    NSLog(@"Ref %@",uploadRef);
    FIRStorageReference *storageRef = [[storage referenceForURL:uploadRef] child:[NSString stringWithFormat:@"%@/%@.%@",imageTatbleName,[TattooUtilis generateRandomID],[self contentTypeForImageData:imageData]]];
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.cacheControl = @"public,max-age=300";
    metadata.contentType = @"image/jpeg";
    [storageRef putData:imageData metadata:metadata completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""]) {
        textView.text  = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([text isEqualToString:@"\n"]) {
        NSLog(@"Return Pressed");
        [textView resignFirstResponder];
    }else
    {
        
    }
    return YES;
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
