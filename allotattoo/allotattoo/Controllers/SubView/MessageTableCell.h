//
//  MessageTableCell.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblChatTIme;
@property (weak, nonatomic) IBOutlet UILabel *lblChatContent;

@end
