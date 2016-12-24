//
//  FavorTattooModel.h
//  allotattoo
//
//  Created by My Star on 7/14/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>




@interface FavorTattooModel : JSONModel
@property NSString<Optional> *user_id;
@property NSString<Optional> *favortattoo_id;
@property NSString<Optional> *favortattoo_url;
@property NSNumber<Optional> *dislike_flag;
@property NSNumber<Optional> *index;
@end
