//
//  LinkedInServiceManager.m
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import "LinkedInServiceManager.h"
#import <Foundation/Foundation.h>
#import "LinkedInAuthorizationViewController.h"
#import "LinkedInConsts.h"
#import "AFNetworking.h"
#import "LinkedinNavBar.h"

@interface LinkedInServiceManager ()

@property(nonatomic, weak) UIViewController *presentingViewController;
@property (nonatomic, copy, readwrite) NSString *clientId;
@property (nonatomic, copy, readwrite) NSString *redirectURI;
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, copy, readwrite) NSString *scope;

@end

@implementation LinkedInServiceManager

+ (LinkedInServiceManager *)serviceForPresentingViewController:viewController{
    LinkedInServiceManager *service = [[self alloc] init];
    service.presentingViewController = viewController;
    
    return service;
}

- (void)passServiceProperties:(NSString *)clientId redirectURI:(NSString *)redirectURI state:(NSString *)state scope:(NSString *)scope{
    
    self.clientId = clientId;
    self.redirectURI = redirectURI;
    self.state = (state != nil || ![state  isEqual: @""]) ? state : @"someState";
    self.scope = scope;
    
}

- (void)getAuthorizationCode:(void (^)(NSString *))success
                      cancel:(void (^)(void))cancel
                     failure:(void (^)(NSError *))failure {
    
    __weak typeof (self) weakSelf = self;
    
    LinkedInAuthorizationViewController *vc = [[LinkedInAuthorizationViewController alloc] initWithServiceManager:self];
    [vc passServiceProperties:self.clientId redirectURI:self.redirectURI state:self.state scope:self.scope];
    
    vc.showActivityIndicator = _showActivityIndicator;
    
    if (self.presentingViewController == nil){
        self.presentingViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
    }
    
    
    
    [vc setAuthorizationCodeCancelCallback:^{
        [weakSelf hideAuthenticateView];
        if (cancel) {
            cancel();
        }
    }];
    
    [vc setAuthorizationCodeFailureCallback:^(NSError *err) {
        [weakSelf hideAuthenticateView];
        if (failure) {
            failure(err);
        }
    }];
    
    [vc setAuthorizationCodeSuccessCallback:^(NSString *code) {
        [weakSelf hideAuthenticateView];
        if (success) {
            success(code);
        }
    }];
    
    UINavigationController *navigationController= [[UINavigationController alloc] initWithNavigationBarClass:[LinkedinNavBar class] toolbarClass:nil];
    [navigationController setViewControllers:@[vc] animated:NO];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self.presentingViewController presentViewController:navigationController animated:YES completion:nil];
}

-(void)getAccessCode:(NSString *)authToken redirectURI:(NSString *)redirectURI
            clientId:(NSString *)clientId clientSecret:(NSString *)clientSecret
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure{
    
    NSString *accessTokenSuffix = [LinkedInAccessTokenRequestURL stringByAppendingString:@"?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@"];
    NSString *linkedInAccessTokenURL = [NSString stringWithFormat:accessTokenSuffix, authToken, redirectURI, clientId, clientSecret];
    NSURL *URL = [NSURL URLWithString:linkedInAccessTokenURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

-(void)fetchUserInfo:(NSString *)accessToken
             success:(void (^)(NSDictionary *))success
             failure:(void (^)(NSError *))failure{
    
    NSString *userURL = [LinkedInUserProfileRequestURL stringByAppendingString:@"&oauth2_access_token=%@"];
    NSString *fullUserURL = [NSString stringWithFormat:userURL, accessToken];
    
    NSURL *URL = [NSURL URLWithString:fullUserURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(error);
    }];
}

#pragma view controller helpers

- (void)hideAuthenticateView {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
