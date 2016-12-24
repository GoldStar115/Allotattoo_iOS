//
//  UserModel.h
//  AllTattoo
//
//  Created by My Star on 7/7/16.
//  Copyright © 2016 AllTattoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>



@interface UserModel : JSONModel
@property NSString<Optional> *user_provideFBID;
@property NSString<Optional> *user_Name;
@property NSString<Optional> *user_id;
@property NSString<Optional> *user_email;
@property NSURL   <Optional> *user_photoURL;
@property NSString<Optional> *userLocation;
@property NSString<Optional> *userRefreshToken;
@property NSString<Optional> *userRegistreationToken;
@property NSString<Optional> *userKey;
@property NSString<Optional> *createdAt;
@property NSString<Optional> *tattooshop_id;
//if userflag == 1 tattooist or not user
@property NSNumber<Optional> *user_flag;
@property NSNumber<Optional> *tattooist_flag;
@property NSString<Optional> *provideINSID;

+(UserModel*) instance;
@end
