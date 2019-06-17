//
//  LinkedInHelper.h
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinkedInHelper : NSObject

+ (LinkedInHelper *)sharedInstance;
- (void)getAuthorized:(id)sender
             clientId:(NSString *)clientId
         clientSecret:(NSString *)clientSecret
          redirectUrl:(NSString *)redirectUrl
                state:(NSString *)state
                scope:(NSString *)scope
      successUserInfo:( void (^) (NSString *sucessMessage) )successUserInfo
          cancelBlock:( void (^) (void) )cancelBlock
    failUserInfoBlock:( void (^) (NSError *error))failure;
- (void) fetchAccessToken:(NSString *)authToken redirectUrl:(NSString *)redirectUrl clientId:          (NSString *)clientId clientSecret:(NSString *)clientSecret
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failure;
- (void)fetchUserInfo:(void(^) (NSDictionary *userInfo))successUserInfo
         failUserInfo:(void(^) (NSString *error))failure;


@property (nonatomic, assign) BOOL showActivityIndicator;

@end

NS_ASSUME_NONNULL_END
