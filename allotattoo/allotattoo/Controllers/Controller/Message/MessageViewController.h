//
//  MessageViewController.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTableCell.h"

@interface MessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnMessageEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UITableView *messageTable;

@property NSMutableArray *arrMessageStr;
@property NSMutableArray *arrMessageUserPic;
@property NSMutableArray *arrMessageTime;
@property NSMutableArray *arrName;
@end
