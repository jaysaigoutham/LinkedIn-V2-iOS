//
//  ViewController.h
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnConnectToLinkedIn;
@property (weak, nonatomic) IBOutlet UILabel *lblConnectedStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnFetchUserData;
@property (weak, nonatomic) IBOutlet UILabel *lblResult;
- (IBAction)onConnectToLinkedInButtonPressed:(id)sender;

- (IBAction)onFetchUserDataButtonPressed:(id)sender;

@end

