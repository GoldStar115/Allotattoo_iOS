//
//  TattoistModel.h
//  allotattoo
//
//  Created by My Star on 7/13/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface TattoistModel : JSONModel
@property NSString<Optional> *tattooist_provideID;
@property NSString<Optional> *tattoist_Name;
@property NSString<Optional> *tattoist_ID;
@property NSString<Optional> *tattoist_email;
@property NSURL   <Optional>  *tattoist_photoURL;
@property NSString<Optional> *tattoistLocation;
@property NSString<Optional> *tattooistKey;
@property NSString<Optional> *tattooistRefreshToken;
@property NSString  <Optional> *createdAt;
+(TattoistModel *) instance;
@end
