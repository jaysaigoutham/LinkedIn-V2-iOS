//
//  LinkedInAuthorizationViewController.h
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkedInServiceManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LinkedInAuthorizationViewController : UIViewController

- (instancetype)initWithServiceManager:(LinkedInServiceManager *)manager;
- (void)passServiceProperties:(NSString *)clientId redirectURI:(NSString *)redirectURI state:(NSString *)state scope:(NSString *)scope;

@property (nonatomic, assign) BOOL showActivityIndicator;

@property (nonatomic, copy) void (^authorizationCodeSuccessCallback)(NSString *code);
@property (nonatomic, copy) void (^authorizationCodeCancelCallback)(void);
@property (nonatomic, copy) void (^authorizationCodeFailureCallback)(NSError *err);

@end

NS_ASSUME_NONNULL_END
