//
//  SelectTattoShopViewController.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhotoPushViewController.h"

@interface SelectTattoShopViewController : UIViewController<UITextFieldDelegate>
@property NSMutableArray *arrArtistName;
@property NSMutableArray *arrArtistPICs;
@property NSMutableArray *arrCheckStatus;
@property NSMutableArray *arrTattooShop;
@property (weak, nonatomic) IBOutlet UISearchBar *searchTattooshop;
@property (weak, nonatomic) IBOutlet UITableView *tblTattooShop;
@property (weak, nonatomic) IBOutlet UIView *viewValid;
@property (weak, nonatomic) IBOutlet UITextField *txtSearch;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;

@end
