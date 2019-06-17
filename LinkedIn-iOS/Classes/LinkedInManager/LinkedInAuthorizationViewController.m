//
//  LinkedInAuthorizationViewController.m
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import "LinkedInAuthorizationViewController.h"
#import "LinkedInServiceManager.h"
#import "LinkedInConsts.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface LinkedInAuthorizationViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) LinkedInServiceManager *serviceManager;
@property (nonatomic, assign, getter=isHandling) BOOL handling;
@property (nonatomic, copy, readwrite) NSString *clientId;
@property (nonatomic, copy, readwrite) NSString *redirectURI;
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, copy, readwrite) NSString *scope;

@end

int loaderTag = 0123; //unique id to identify the loading view

@implementation LinkedInAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(btnCancelTapped:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    [self.view addSubview:self.webView];
    
    if (self.showActivityIndicator) {
        [self showIndicatorWithStyle:UIActivityIndicatorViewStyleGray];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *authURL = [LinkedInAuthTokenRequestURL stringByAppendingString:@"?response_type=code&client_id=%@&redirect_uri=%@&state=%@&scope=%@"];
    NSString *linkedIn = [NSString stringWithFormat:authURL, self.clientId, self.redirectURI, self.state, self.scope];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:linkedIn]]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

#pragma mark - Initialize

- (instancetype)initWithServiceManager:(LinkedInServiceManager *)manager {
    self = [super init];
    if (self) {
        self.serviceManager = manager;
    }
    
    return self;
}

#pragma mark - passing params

- (void)passServiceProperties:(NSString *)clientId redirectURI:(NSString *)redirectURI state:(NSString *)state scope:(NSString *)scope{
    
    self.clientId = clientId;
    self.redirectURI = redirectURI;
    self.state = (state != nil || ![state  isEqual: @""]) ? state : @"someState";
    self.scope = scope;
    
}

#pragma mark - Button Actions

- (void)btnCancelTapped:(UIBarButtonItem*)sender {
    
    if (self.authorizationCodeCancelCallback) {
        self.authorizationCodeCancelCallback();
    }
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL] absoluteString];
    self.handling = [url hasPrefix:self.redirectURI];
    
    if (self.isHandling)
    {
        if ([url rangeOfString:@"error"].location != NSNotFound) {
            BOOL accessDenied = [url rangeOfString:@"the+user+denied+your+request"].location != NSNotFound;
            if (accessDenied) {
                if (self.authorizationCodeCancelCallback) {
                    self.authorizationCodeCancelCallback();
                }
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.linkedinioshelper"
                                                            code:1
                                                        userInfo:[[NSMutableDictionary alloc] init]];
                if (self.authorizationCodeFailureCallback) {
                    self.authorizationCodeFailureCallback(error);
                }
            }
        }
        else{
            NSString *receivedState = [self extractGetParameter:@"state" fromURLString: url];
            
            //assert that the state is as we expected it to be
            if ([self.state isEqualToString:receivedState]) {
                //extract the code from the url
                NSString *authorizationCode = [self extractGetParameter:@"code" fromURLString: url];
                if (self.authorizationCodeSuccessCallback) {
                    self.authorizationCodeSuccessCallback(authorizationCode);
                }
            } else {
                NSError *error = [[NSError alloc] initWithDomain:@"com.linkedinioshelper"
                                                            code:2
                                                        userInfo:[[NSMutableDictionary alloc] init]];
                if (self.authorizationCodeFailureCallback) {
                    self.authorizationCodeFailureCallback(error);
                }
            }
        }
    }
    
    return !self.isHandling;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if (!self.isHandling && self.authorizationCodeFailureCallback) {
        self.authorizationCodeFailureCallback(error);
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopIndicator];
}

#pragma mark - Activity Indicator

- (void)showIndicatorWithStyle:(UIActivityIndicatorViewStyle)style
{
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    CGRect selfFrame = self.view.frame;
    indicator.center = CGPointMake(selfFrame.size.width/2, selfFrame.size.height/2);
    indicator.tag = loaderTag;
    [indicator startAnimating];
    [self.webView addSubview:indicator];
}

- (void)stopIndicator {
    
    if ([self.webView viewWithTag:loaderTag] &&
        [[self.webView viewWithTag:loaderTag] isKindOfClass:[UIActivityIndicatorView class]]) {
        
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView*)[self.webView viewWithTag:loaderTag];
        [indicator stopAnimating];
        [indicator removeFromSuperview];
        indicator = nil;
    }
}

#pragma mark - utilities

- (NSString *)extractGetParameter: (NSString *) parameterName fromURLString:(NSString *)urlString {
    
    NSMutableDictionary *mdQueryStrings = [[NSMutableDictionary alloc] init];
    urlString = [[urlString componentsSeparatedByString:@"?"] objectAtIndex:1];
    urlString = [[urlString componentsSeparatedByString:@"#"] objectAtIndex:0];
    for (NSString *qs in [urlString componentsSeparatedByString:@"&"]) {
        [mdQueryStrings setValue:[[[[qs componentsSeparatedByString:@"="] objectAtIndex:1]
                                   stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                          forKey:[[qs componentsSeparatedByString:@"="] objectAtIndex:0]];
    }
    return [mdQueryStrings objectForKey:parameterName];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
