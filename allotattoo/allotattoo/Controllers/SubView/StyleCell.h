//
//  StyleCell.h
//  AllTattoo
//
//  Created by My Star on 7/1/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleContent;
@property (weak, nonatomic) IBOutlet UIButton *btnStyleLike_Dis;
@property (weak, nonatomic) IBOutlet UIImageView *imgPost;

@end
