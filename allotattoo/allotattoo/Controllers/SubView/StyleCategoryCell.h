//
//  StyleCategoryCell.h
//  AllTattoo
//
//  Created by My Star on 7/2/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleCategoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCategory;
@property (weak, nonatomic) IBOutlet UIView *viewSelIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end
