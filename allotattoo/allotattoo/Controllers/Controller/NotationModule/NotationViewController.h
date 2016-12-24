//
//  NotationViewController.h
//  allotattoo
//
//  Created by My Star on 8/30/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "MenuViewController.h"
#import "PhotoFeedViewController.h"
#import <FBSDKLoginKit/FBSDKLoginManagerLoginResult.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <FBSDKAccessToken.h>
#import <MBProgressHUD.h>
#import "UserModel.h"
#import "utilities.h"
@interface NotationViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnINS;
@property (weak, nonatomic) IBOutlet UIButton *btnFB;

@end
