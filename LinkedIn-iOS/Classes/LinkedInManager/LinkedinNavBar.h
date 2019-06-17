//
//  LinkedinNavBar.h
//  LinkedIn-iOS
//
//  Created by Jayasai on 6/12/19.
//  Copyright © 2019 Jayasai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LinkedinNavBar : UINavigationBar

@property(nullable,nonatomic,copy) NSDictionary<NSAttributedStringKey, id> *authBarTitleTextAttributes NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(nullable,nonatomic,copy) NSDictionary<NSAttributedStringKey, id> *authCancelButtonTitleTextAttributes NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) BOOL authBarIsTranslucent UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor * _Nullable authTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor * _Nullable authBarTintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSString * _Nullable authTitle UI_APPEARANCE_SELECTOR;


@end

NS_ASSUME_NONNULL_END
