//
//  LinkedInServiceManager.h
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinkedInServiceManager : NSObject

+ (LinkedInServiceManager *)serviceForPresentingViewController:viewController;
- (void)passServiceProperties:(NSString *)clientId redirectURI:(NSString *)redirectURI state:(NSString *)state scope:(NSString *)scope;
- (void)getAuthorizationCode:(void (^)(NSString *))success
                      cancel:(void (^)(void))cancel
                     failure:(void (^)(NSError *))failure;
-(void)getAccessCode:(NSString *)authToken redirectURI:(NSString *)redirectURI
            clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure;
-(void)fetchUserInfo:(NSString *)accessToken
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure;

@property (nonatomic, assign) BOOL showActivityIndicator;

@end

NS_ASSUME_NONNULL_END
