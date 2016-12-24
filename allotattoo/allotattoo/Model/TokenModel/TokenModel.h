//
//  TokenModel.h
//  allotattoo
//
//  Created by My Star on 8/2/16.
//  Copyright © 2016 My Star. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TokenModel : JSONModel
@property NSString<Optional> *user_id;
@property NSString<Optional> *regist_token;
@property NSString<Optional> *token_key;
@end
