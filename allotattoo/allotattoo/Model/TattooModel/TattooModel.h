//
//  TattooModel.h
//  allotattoo
//
//  Created by My Star on 7/12/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSONModel.h>

@interface TattooModel : JSONModel

@property NSString<Optional> *user_id;
@property NSString<Optional> *tattoo_image_url;
@property NSNumber<Optional> *like_flag;
@property NSString<Optional> *tattoo_id;
@property NSString<Optional> *style_id;
@property NSString<Optional> *category_id;
@property NSString<Optional> *tattooShop_id;
@property NSString<Optional> *tattoo_link;
@property NSNumber<Optional> *like_number;
@property NSNumber<Optional> *comment_number;
@property NSString<Optional> *tattoo_name;
@property NSString<Optional> *tattoist_ID;

@end


