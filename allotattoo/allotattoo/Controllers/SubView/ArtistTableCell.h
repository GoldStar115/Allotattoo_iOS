//
//  ArtistTableCell.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
@property (weak, nonatomic) IBOutlet UILabel *lblArtistName;

@property (weak, nonatomic) IBOutlet UIImageView *imgArtistPIC;
@end
