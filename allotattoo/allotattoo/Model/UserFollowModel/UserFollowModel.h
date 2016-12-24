//
//  UserFollowModel.h
//  allotattoo
//
//  Created by My Star on 7/31/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface UserFollowModel : JSONModel
@property NSString<Optional> *user_id;
@property NSString<Optional> *follower_id;
@property NSString<Optional> *follower_photo_url;
@end
