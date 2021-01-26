#import <__wctype.h>
//
// Created by Аполлов Юрий Андреевич on 17.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

@import CoreGraphics;

@import GoogleMobileAds;

#import "GoogleAdsViewController.h"

#import "SDL_uikitviewcontroller+GoogleAds+Gamepad.h"

@implementation SDL_uikitviewcontroller (GoogleAdsAndGamepad)

#pragma Common

// determined empirically, on lesser sizes main menu run away screaming
static CGSize _minSize = {632, 368};

- (void)viewDidAppear:(BOOL)animated {
    if ([self shouldHaveTopBanner])
        [self initBannerWindow];
    [self initScreenControlsWindow:animated];
}

#pragma GoogleAds

- (CGFloat)getBannerHeight {
    return [GoogleAdsViewController getBannerSize].size.height;
}

- (BOOL)shouldHaveTopBanner {
    CGFloat mainScreenHeight = UIScreen.mainScreen.bounds.size
                                       .height - [self getBannerHeight];
    return (mainScreenHeight >= _minSize.height);
}

- (void)initBannerWindow {
    _adsWindow = [UIWindow new];
    _adsWindow.rootViewController = [GoogleAdsViewController new];
    _adsWindow.hidden = NO;
    [self updateBannerAndMainWindows];
}

- (void)updateBannerAndMainWindows {
    UIScreen* screen = [UIScreen mainScreen];
    UIWindow* mainWindow = self.view.window;
    CGFloat screenWidth = screen.bounds.size.width;
    CGFloat bannerHeight = [self getBannerHeight];

    _adsWindow.frame = (CGRect)
            {
                    .origin = CGPointZero,
                    .size = (CGSize)
                            {
                                    screenWidth,
                                    bannerHeight,
                            }
            };

    CGFloat freeScreenHeight = screen.bounds.size.height - bannerHeight;
    mainWindow.frame = (CGRect)
            {
                    .origin = (CGPoint) {0, bannerHeight},
                    .size = (CGSize) {screenWidth, freeScreenHeight},
            };
}

UIWindow* _adsWindow;

#pragma Gamepad

- (void)initScreenControlsWindow:(__unused BOOL)animated {
    _gamepadViewController = [
            [UIStoryboard storyboardWithName:@"UIControls" bundle:nil]
            instantiateInitialViewController];
    [self.view addSubview:_gamepadViewController.view];
    [self updateFrame];

    for (NSString* notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
        [[NSNotificationCenter defaultCenter]
                               addObserver:self selector:@selector(updateFrame)
                                                name:notification object:nil];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if ([self shouldHaveTopBanner])
        [self updateBannerAndMainWindows];
    [self updateFrame];
}

- (void)updateFrame {
    CGRect viewFrame = self.view.frame;
    CGFloat viewHeight = viewFrame.size.height;
    CGRect frame = [_gamepadViewController.view frame];
    frame.origin.x = frame.origin.y = 0;
    frame.size.height = viewHeight - self.keyboardHeight;
    frame.size.width = viewFrame.size.width;
    [_gamepadViewController.view setFrame:frame];
}

GamePadViewController* _gamepadViewController;
@dynamic keyboardHeight;

@end