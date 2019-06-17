//
//  LinkedInHelper.m
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import "LinkedInHelper.h"
#import "LinkedInServiceManager.h"

@interface LinkedInHelper ()

@property (nonatomic, strong) LinkedInServiceManager *service;
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, copy) NSString *redirectURL;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *accessTokenExpiryDate;
@property (nonatomic, strong) id sender;
@property (nonatomic, copy) void (^userInfoSuccessBlock)(NSString *userInfo);
@property (nonatomic, copy) void (^cancelBlock)(void);
@property (nonatomic, copy) void (^dismissFailBlock)(NSError *error);

@end

@implementation LinkedInHelper

#pragma mark - Initialize
+ ( LinkedInHelper * )sharedInstance {
    
    static dispatch_once_t predicate;
    static LinkedInHelper *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[LinkedInHelper alloc] init];
        sharedInstance.service = [LinkedInServiceManager new];
    });
    return sharedInstance;
}

#pragma mark - helper meathods
- (void)getAuthorized:(id)sender
             clientId:(NSString *)clientId
         clientSecret:(NSString *)clientSecret
          redirectUrl:(NSString *)redirectUrl
                state:(NSString *)state
                scope:(NSString *)scope
      successUserInfo:( void (^) (NSString *sucessMessage) )successCode
          cancelBlock:( void (^) (void) )cancelBlock
    failUserInfoBlock:( void (^) (NSError *error))failure{
    
    
    self.clientId = clientId;
    self.clientSecret = clientSecret;
    self.redirectURL = redirectUrl;
    self.state = state.length ? state : @"samplestate";
    self.scope = scope;
    
    self.service = [LinkedInServiceManager serviceForPresentingViewController:sender];
    [self.service passServiceProperties:self.clientId redirectURI:self.redirectURL  state:self.state scope:self.scope];
    self.service.showActivityIndicator = self.showActivityIndicator;
    
    self.sender = sender;
    _userInfoSuccessBlock = successCode;
    _dismissFailBlock = failure;
    _cancelBlock = cancelBlock;
    
    __weak typeof(self) weakSelf = self;
    
    
    [self.service getAuthorizationCode:^(NSString * code) {
        //Sucess
        //TODO: save Authcode in keychain
        [self fetchAccessToken:code redirectUrl:redirectUrl clientId:clientId clientSecret:clientSecret success:^(NSDictionary * accessCode) {
            self.accessToken = [accessCode valueForKeyPath:@"access_token"];
            self.accessTokenExpiryDate = [accessCode valueForKeyPath:@"expires_in"];
            successCode(@"done");
        } failure:^(NSError * error) {
            failure(error);
        }];
        
    } cancel:^{
        weakSelf.cancelBlock();
    } failure:^(NSError * error) {
        weakSelf.dismissFailBlock(error);
    }];
    
}

- (void) fetchAccessToken:(NSString *)authToken redirectUrl:(NSString *)redirectUrl clientId:          (NSString *)clientId clientSecret:(NSString *)clientSecret
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(NSError *))failure{
    
    [self.service getAccessCode:authToken redirectURI:redirectUrl clientId:clientId clientSecret:clientSecret success:^(NSDictionary * accessCode) {
        success(accessCode);
    } failure:^(NSError * error) {
        failure(error);
    }];
}


- (void)fetchUserInfo:(void(^) (NSDictionary *userInfo))successUserInfo
         failUserInfo:(void(^) (NSString *error))failure{
    [self.service fetchUserInfo:self.accessToken success:^(NSDictionary * result){
        NSLog(@"sucess");
        successUserInfo(result);
    } failure:^(NSError * error) {
        failure(@"Unable to retrive infor");
    }];
}


@end
