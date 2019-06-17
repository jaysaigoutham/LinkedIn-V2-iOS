//
//  LinkedinNavBar.m
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import "LinkedinNavBar.h"

@implementation LinkedinNavBar

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setTintColor:[UIColor colorNamed:@"ColorPrimary"]];
        [self setBarTintColor:[UIColor colorNamed:@"ColorPrimary"]];
        
    }
    return self;
}

#pragma mark - Appearence Setters

- (void)setAuthBarTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)authBarTitleTextAttributes {
    
    _authBarTitleTextAttributes = authBarTitleTextAttributes;
    [self setTitleTextAttributes:authBarTitleTextAttributes];
}

- (void)setAuthCancelButtonTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)authCancelButtonTitleTextAttributes {
    
    _authCancelButtonTitleTextAttributes = authCancelButtonTitleTextAttributes;
    [self.topItem.leftBarButtonItem setTitleTextAttributes:authCancelButtonTitleTextAttributes forState:UIControlStateNormal];
}

- (void)setAuthBarTintColor:(UIColor *)authBarTintColor {
    
    _authBarTintColor = authBarTintColor;
    [self setBarTintColor:authBarTintColor];
}

- (void)setAuthBarIsTranslucent:(BOOL)authBarIsTranslucent {
    
    _authBarIsTranslucent = authBarIsTranslucent;
    [self setTranslucent:authBarIsTranslucent];
}

- (void)setAuthTintColor:(UIColor *)authTintColor {
    
    _authTintColor = authTintColor;
    [self setTintColor:authTintColor]; //authTintColor
}

- (void)setAuthTitle:(NSString *)authTitle {
    
    _authTitle = authTitle;
    [self.topItem setTitle:authTitle];
}

@end
