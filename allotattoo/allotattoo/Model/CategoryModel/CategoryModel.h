//
//  CategoryModel.h
//  allotattoo
//
//  Created by My Star on 7/25/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CategoryModel : JSONModel
@property NSString<Optional> *category_id;
@property NSString<Optional> *category_img_url;
@property NSString<Optional> *category_title;
@property NSString<Optional> *category_description;
@end
