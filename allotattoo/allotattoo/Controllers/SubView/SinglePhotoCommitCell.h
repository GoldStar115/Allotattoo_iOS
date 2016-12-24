//
//  SinglePhotoCommitCell.h
//  AllTattoo
//
//  Created by My Star on 7/3/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePhotoCommitCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserPic;
@property (weak, nonatomic) IBOutlet UILabel *labDate;

@property (weak, nonatomic) IBOutlet UILabel *lblCommitName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommitContent;

@end
