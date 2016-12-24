//
//  StyleModel.h
//  allotattoo
//
//  Created by My Star on 7/13/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>




@interface StyleModel : JSONModel
@property NSString<Optional> *user_id;
@property NSString<Optional> *style_image_url;
@property NSNumber<Optional> *like_flag;
@property NSString<Optional> *style_title;
@property NSString<Optional> *style_des;
@property NSString<Optional> *style_id;
@end
