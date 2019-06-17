//
//  ViewController.m
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import "ViewController.h"
#import "LinkedInHelper.h"
#import "LinkedInConsts.h"

@interface ViewController ()

@end

@implementation ViewController{
    BOOL linkedInConnected;
    LinkedInHelper *linkedIn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //when application starts display linkedIn Not connected
    linkedInConnected = false;
    _btnFetchUserData.enabled = false;
}


- (IBAction)onConnectToLinkedInButtonPressed:(id)sender {
    
     linkedIn = [LinkedInHelper sharedInstance];
    
    [linkedIn getAuthorized:self clientId:LinkedInClientId clientSecret:LinkedInClientSecret redirectUrl:LinkedInRedirectURL state:LinkedInState scope:LinkedInPermissions successUserInfo:^(NSString * _Nonnull userInfo) {
        
        self.lblConnectedStatus.text = @"connected";
        self.lblConnectedStatus.textColor = UIColor.greenColor;
        self.btnFetchUserData.enabled = true;
        linkedInConnected = true;
        
    } cancelBlock:^{
        // no UI actions required
    } failUserInfoBlock:^(NSError * _Nonnull error) {
        linkedInConnected = false;
        self.lblConnectedStatus.text = @"not connected";
        self.lblConnectedStatus.textColor = UIColor.redColor;
    }];
    
}

- (IBAction)onFetchUserDataButtonPressed:(id)sender {
    
    [linkedIn fetchUserInfo:^(NSDictionary * userInfo) {
        _lblResult.text = [NSString stringWithFormat:@"%@", userInfo];
    } failUserInfo:^(NSString * error) {
        _lblResult.text = @"error";
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Data Sync failed"
                                                                       message:@"An error occured!"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
@end
