//
//  TattooShopModel.h
//  allotattoo
//
//  Created by My Star on 7/25/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TattooShopModel : JSONModel
@property NSString<Optional> *tattooshop_id;
@property NSString<Optional> *tattoo_shop_location;
@property NSString<Optional> *tattoo_shop_img_url;
@property NSString<Optional> *tattoo_shop_link;
@property NSString<Optional> *tattoo_shop_name;
@property NSString<Optional> *user_id;
@end
