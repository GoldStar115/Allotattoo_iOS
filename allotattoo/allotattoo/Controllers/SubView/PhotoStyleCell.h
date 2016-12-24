//
//  PhotoStyleCell.h
//  AllTattoo
//
//  Created by My Star on 7/4/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoStyleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblStyleTitle;
@property (weak, nonatomic) IBOutlet UIView *viewBlur;

@end
