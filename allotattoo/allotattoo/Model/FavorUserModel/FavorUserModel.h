//
//  FavorUserModel.h
//  allotattoo
//
//  Created by My Star on 7/25/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FavorUserModel : JSONModel
@property NSString<Optional> *favor_user_id;
@property NSString<Optional> *user_id;
@property NSString<Optional> *favor_user_photo_url;
@end
