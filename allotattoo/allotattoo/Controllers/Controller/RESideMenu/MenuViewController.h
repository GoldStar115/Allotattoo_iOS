//
//  MenuViewController.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import "RecentView.h"
#import "AlloTattoAppDelegate.h"
#import "TrappedView.h"
#import "NotationViewController.h"
@interface MenuViewController : UIViewController<RecentViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnStyles;
@property (weak, nonatomic) IBOutlet UIButton *btnInspiration;
@property (weak, nonatomic) IBOutlet UIButton *btnMonComplete;
@property (weak, nonatomic) IBOutlet UIButton *btnMesFavoris;
@property (weak, nonatomic) IBOutlet UIButton *btnNotification;
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnDeconnect;
@property (weak, nonatomic) IBOutlet UIButton *btnUserProfile;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;

- (void)onLogoutEngine;
@property (weak, nonatomic) IBOutlet UIImageView *imgMsgBadge;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgCounter;
@property (weak, nonatomic) IBOutlet UIImageView *imgNotiBadge;
@property (weak, nonatomic) IBOutlet UILabel *lblNotiCounter;

@property (weak, nonatomic) IBOutlet TrappedView *trappedView;

@end
