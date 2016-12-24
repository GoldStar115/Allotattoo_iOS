//
//  CommentModel.h
//  allotattoo
//
//  Created by My Star on 7/25/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface CommentModel : JSONModel
@property NSString<Optional> *user_id;
@property NSString<Optional> *user_photoURL;
@property NSString<Optional> *user_Name;
@property NSString<Optional> *tattoo_id;
@property NSString<Optional> *comment_id;
@property NSString<Optional> *comment_content;
@property NSString<Optional> *createdAt;
@end
