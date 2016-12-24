//
//  PhotoSubmitViewController.m
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "PhotoSubmitViewController.h"
#import "PhotoPushViewController.h"
#import <DBCameraContainerViewController.h>
#import <DBCameraViewController.h>

@interface PhotoSubmitViewController ()<DBCameraViewControllerDelegate>
{
    BOOL isFirst;

}
@end

@implementation PhotoSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isFirst = NO;
    [self.viewCaption setHidden:YES];
    self.imgSubmitPhoto.image = _imageCaptured;

    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_imgLogo setHidden:YES];
    [_lblPost setHidden:YES];
    [_btnCapture setHidden:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onSubmitPhoto:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        PhotoPushViewController  *photoPushVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoPushViewController"];
        if (self.imgSubmitPhoto.image != nil) {
            photoPushVC.imgCapture = self.imgSubmitPhoto.image;
            photoPushVC.imgCaptureInside = self.imgSubmitPhoto.image;
        }
        [self.navigationController pushViewController:photoPushVC animated:YES];
    }else{
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }

}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)onOpenCamera:(id)sender {
    [self openCamera];
}

- (void) openCamera
{
    isFirst = YES;
    DBCameraContainerViewController *cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    [cameraContainer setFullScreenMode];    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - DBCameraViewControllerDelegate

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    [self.viewCaption setHidden:YES];
    dispatch_async(dispatch_get_main_queue(), ^{

            self.imgSubmitPhoto.image = image;
    });
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void) dismissCamera:(id)cameraViewController{
    [self.viewCaption setHidden:YES];
//    self.imgSubmitPhoto.image = [UIImage imageNamed:@"imgTakeSamplePIC"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}
#pragma mark ImageMerge
-(UIImage *)postMergeImage
{
    [_btnCapture setHidden:YES];

    [_imgLogo setHidden:NO];
    [_lblPost setHidden:NO];
    UIGraphicsBeginImageContext(_viewPost.bounds.size);
    [_viewPost.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  finalImage;
}

@end
