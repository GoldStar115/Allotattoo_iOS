//
//  ArtistProfileSettingViewController.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MBProgressHUD.h>
@interface ArtistProfileSettingViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistName;
@property (weak, nonatomic) IBOutlet UILabel *lblTattooShopName;
@property NSDictionary *userDic;;
@property (weak, nonatomic) IBOutlet UIView *viewMask;
@property (weak, nonatomic) IBOutlet UISwitch *switchPushNotiSetting;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectedIns;

@end
