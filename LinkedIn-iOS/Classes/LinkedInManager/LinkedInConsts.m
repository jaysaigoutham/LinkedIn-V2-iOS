//
//  LinkedInConsts.m
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import "LinkedInConsts.h"

@implementation LinkedInConsts

NSString const *LinkedInAuthTokenRequestURL = @"https://www.linkedin.com/oauth/v2/authorization";

NSString const *LinkedInAccessTokenRequestURL = @"https://www.linkedin.com/oauth/v2/accessToken";

NSString const *LinkedInUserProfileRequestURL = @"https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,educations,profilePicture(displayImage~:playableStreams))";


NSString const *LinkedInClientId = @""; //place the client ID here

NSString const *LinkedInClientSecret = @""; //place the client secret here

NSString const *LinkedInRedirectURL = @""; //place the redirect URL here

NSString const *LinkedInState = @""; //place the state here

NSString const *LinkedInPermissions = @"r_liteprofile%20r_emailaddress%20w_member_social";

@end
