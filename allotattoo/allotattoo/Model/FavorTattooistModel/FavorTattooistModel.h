//
//  FavorTattooistModel.h
//  allotattoo
//
//  Created by My Star on 7/25/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FavorTattooistModel : JSONModel
@property NSString<Optional> *favor_tattooist_id;
@property NSString<Optional> *tattooist_id;
@property NSString<Optional> *favor_tattooist_photo_url;
@end
