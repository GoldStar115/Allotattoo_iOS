//
//  ProfileSettingViewController.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constant.h"
#import <MBProgressHUD.h>
@interface ProfileSettingViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblNickName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPIC;
@property (weak, nonatomic) IBOutlet UIView *viewMask;
@property (weak, nonatomic) IBOutlet UISwitch *switchPushNotification;
@property (weak, nonatomic) IBOutlet UILabel *lblInsConnect;

@property UserModel *userModel;
@property NSDictionary *userDict;
@end
