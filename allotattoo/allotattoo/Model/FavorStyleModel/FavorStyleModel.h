//
//  FavorStyleModel.h
//  allotattoo
//
//  Created by My Star on 7/14/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>


@interface FavorStyleModel : JSONModel
@property NSString<Optional> *user_id;
@property NSString<Optional> *favorstyle_id;
@property NSString<Optional> *favorstyle_url;
@end
