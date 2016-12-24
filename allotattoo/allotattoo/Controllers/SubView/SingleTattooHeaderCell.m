//
//  SingleTattooHeaderCell.m
//  allotattoo
//
//  Created by My Star on 8/24/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import "SingleTattooHeaderCell.h"

@implementation SingleTattooHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_lblCommitNumber setHidden:NO];
    [_btnCommit setTag:0];
    [_btnLike setTag:1];
    [_btnShare setTag:2];
    [_btnTattoistProfile setTag:3];
    
    _viewMainAction.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewMainAction.layer.borderWidth = 0.0f;
    dispatch_async(dispatch_get_main_queue(), ^{
        _imgArtistPic.layer.backgroundColor=[[UIColor clearColor] CGColor];
        _imgArtistPic.layer.cornerRadius=_imgArtistPic.frame.size.height/2;
        _imgArtistPic.clipsToBounds = YES;
        _imgArtistPic.layer.borderColor=[[UIColor redColor] CGColor];
    });
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
