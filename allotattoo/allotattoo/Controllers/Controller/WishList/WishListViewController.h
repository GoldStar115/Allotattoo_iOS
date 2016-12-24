//
//  WishListViewController.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "utilities.h"

@interface WishListViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnMyLikeTattoos;
@property (weak, nonatomic) IBOutlet UIButton *btnConnectIns;
@property (weak, nonatomic) IBOutlet UIButton *btnConnectFB;
@property BOOL loginedFlag;
@property (weak, nonatomic) IBOutlet UIImageView *imgWishList;
@property (weak, nonatomic) IBOutlet UIButton *btnWishList;
@property (weak, nonatomic) IBOutlet UILabel *lblWishDes;
@property (weak, nonatomic) IBOutlet UIButton *btnConnectWithIns;
@property (weak, nonatomic) IBOutlet UIButton *btnQU;
@property (weak, nonatomic) IBOutlet UIButton *btnConnectWithFB;

@end
