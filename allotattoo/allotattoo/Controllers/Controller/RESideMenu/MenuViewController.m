//
//  MenuViewController.m
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import "MenuViewController.h"
#import "WishListNoViewController.h"
#import "UserProfileViewController.h"
#import "PhotoFeedViewController.h"
#import "MesFavorisViewController.h"
#import "WishListViewController.h"
#import "MessageViewController.h"
#import "NotificationViewController.h"
#import "AboutUSViewController.h"
#import "OnBoardingRootViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserModel.h"

@import Firebase;

@interface MenuViewController ()
{
    NSURL *photoURL;
    RecentView *recentView;
}
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initCustomUI];
    });

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImage:) name:@"UpdateImage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge:) name:@"Updatebadge" object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initCustomUI];
    });

}
- (void)viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initCustomUI];
    });
}
- (void)viewDidDisappear:(BOOL)animated
{
}
- (void)updateImage:(NSNotification *)notication{
    if ([notication.name isEqualToString:@"UpdateImage"]) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:notication.userInfo[@"image"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [_trappedView addSubview:imageView];
    }
}
- (void)updateBadge:(NSNotification *)notication{
    if ([notication.name isEqualToString:@"Updatebadge"]) {
        if (notication.userInfo[@"badgecount"] > 0) {
            [_imgNotiBadge setHidden:NO];
            [_lblNotiCounter setHidden:NO];
            NSNumber *badgeNumber = notication.userInfo[@"badgecount"];
            NSLog(@"%d",(int)badgeNumber.intValue);
            [self.lblNotiCounter setText:[NSString stringWithFormat:@"%d",badgeNumber.intValue]];
        }
    }
}
- (void)updateDadgeNumber:(NSInteger)counter
{
    [_imgNotiBadge setHidden:NO];
    [_lblNotiCounter setHidden:NO];
    [self.lblNotiCounter setText:[NSString stringWithFormat:@"%d",(int)[SharedModel instance].arrNotificationModel.count]];
}
- (void)initCustomUI{
    recentView = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentView"];
    recentView.delegate = self;
    
    [_lblMsgCounter setHidden:YES];
    [_imgMsgBadge setHidden:YES];
    [_imgNotiBadge setHidden:YES];
    [_lblNotiCounter setHidden:YES];
    _imgUserPic.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _imgUserPic.layer.cornerRadius=_imgUserPic.frame.size.width/2;
    _imgUserPic.clipsToBounds = YES;
    _imgUserPic.layer.borderColor=[[UIColor redColor] CGColor];
    photoURL = [FIRAuth auth].currentUser.photoURL;

    [_imgUserPic sd_setImageWithURL:photoURL placeholderImage:[UIImage imageNamed:@"no_photo"]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onUserProfile:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        userProfileVC.userProfil_ID = [FIRAuth auth].currentUser.uid;
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:userProfileVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }else{
        NotificationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.navigationController pushViewController:notationVC animated:YES];
    }
    
}
- (IBAction)onStyles:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 1;
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)onInspiration:(id)sender {
    PhotoFeedViewController *photoFeedVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoFeedViewController"];
    [SharedModel instance].feedIndex = 0;
    [SharedModel instance].isInsFiltered = NO;
    [[SharedModel instance].arrInsTattooSearchResult removeAllObjects];
    [[SharedModel instance].arrInsUserSearchResult removeAllObjects];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:photoFeedVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}
- (IBAction)onMonComplete:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        UserProfileViewController *userProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        userProfileVC.userProfil_ID = [FIRAuth auth].currentUser.uid;
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:userProfileVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }else{
        [SharedModel instance].isAnymousProfile = YES;
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:notationVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }

}
- (IBAction)onMesFavoris:(id)sender {
    
    WishListViewController *wishListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
    wishListVC.loginedFlag = YES;
    WishListNoViewController *wishNoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WishListNoViewController"];
    MesFavorisViewController *mesFavorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MesFavorisViewController"];
    mesFavorVC.arrMesFavorisImage = [NSMutableArray array];
    mesFavorVC.arrMesFavorisImage = [TattooUtilis onGetFavorTattooFromTattooModel:[SharedModel instance].arrTattoos];
    if (mesFavorVC.arrMesFavorisImage.count > 0 && [FIRAuth auth].currentUser && [TattooUtilis isReallyUser]) {
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:mesFavorVC] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        });
    }else if(mesFavorVC.arrMesFavorisImage.count <= 0 && [FIRAuth auth].currentUser && [TattooUtilis isReallyUser])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:wishNoVC] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        });
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            wishListVC.loginedFlag  = NO;
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:wishListVC] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        });
        
    }


}

- (IBAction)onHideTapped:(id)sender {
    [self.sideMenuViewController hideMenuViewController];
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
- (IBAction)onNotifications:(id)sender {
    if ([TattooUtilis isReallyUser]) {
        NotificationViewController *navigationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:navigationVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
    else{
        [SharedModel instance].isAnymousNotificaiton = YES;
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:notationVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
}
- (IBAction)onDisconnect:(id)sender {
}
- (IBAction)onMessages:(id)sender {
    
    if ([TattooUtilis isReallyUser]) {
        [SharedModel instance].isMenuChatSelected = YES;
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:recentView] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }else{
        [SharedModel instance].isAnymousMessage = YES;
        NotationViewController *notationVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationViewController"];
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:notationVC] animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
    
}
- (IBAction)onAbout:(id)sender {
    AboutUSViewController *aboutUSVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutUSViewController"];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:aboutUSVC] animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}
- (IBAction)onLogout:(id)sender {
    
    [self onLogoutEngine];

    
}

- (void)onLogoutEngine{

            NSError *signOutError;

            BOOL status = [[FIRAuth auth] signOut:&signOutError];
            if (!status) {
                NSLog(@"Error signing out: %@", signOutError);
                return;
            }else{
                OnBoardingRootViewController *onBoardingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OnBoardingRootViewController"];
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:onBoardingVC] animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                [TattooUtilis resetDefaults];
            }
    
}

#pragma  mark RecentViewDelegate
- (void)updateMessageBadge:(NSInteger)counter
{
    if (counter > 0) {
        [_imgMsgBadge setHidden:NO];
        [_lblMsgCounter setHidden:NO];
        [self.lblMsgCounter setText:[NSString stringWithFormat:@"%d",(int)counter]];
    }

}

@end
