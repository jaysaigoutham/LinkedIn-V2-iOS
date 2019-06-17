//
//  LinkedInConsts.h
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinkedInConsts : NSObject

extern NSString const *LinkedInAuthTokenRequestURL;
extern NSString const *LinkedInAccessTokenRequestURL;
extern NSString const *LinkedInUserProfileRequestURL;

extern NSString const *LinkedInClientId;
extern NSString const *LinkedInClientSecret;
extern NSString const *LinkedInRedirectURL;
extern NSString const *LinkedInState;
extern NSString const *LinkedInPermissions;

@end

NS_ASSUME_NONNULL_END
