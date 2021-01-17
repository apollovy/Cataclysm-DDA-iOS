#import <__wctype.h>
//
// Created by Аполлов Юрий Андреевич on 17.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

@import CoreGraphics;

@import GoogleMobileAds;

#import "GoogleAdsViewController.h"

#import "SDL_uikitviewcontroller+GoogleAds+Gamepad.h"

// FIXME: main menu is not showing. Maybe I'm to start showing ads in a
//  minute or 2? Or maybe replace banner on iPhones to full-screen. Or
//  possibly hide after click for 5 minutes and then move to opposite side of
//  screen?
@implementation SDL_uikitviewcontroller (GoogleAdsAndGamepad)

#pragma GoogleAds

- (void)viewDidAppear:(BOOL)animated {
    _adsWindow = [UIWindow new];
    _adsWindow.rootViewController = [GoogleAdsViewController new];
    _adsWindow.hidden = NO;

    [self updateBannerWindow];
    [self _GamePadViewDidAppear:animated];
}

- (void)updateBannerWindow {
    UIScreen* screen = [UIScreen mainScreen];
    UIWindow* mainWindow = self.view.window;
    CGFloat width = screen.bounds.size.width;
    CGFloat bannerHeight = kGADAdSizeBanner.size.height;

    _adsWindow.frame = (CGRect)
            {
                    .origin = CGPointZero,
                    .size = (CGSize)
                            {
                                    width,
                                    bannerHeight,
                            }
            };

    mainWindow.frame = (CGRect)
            {
                    .origin = (CGPoint) {0, bannerHeight},
                    .size = screen.bounds.size,  // will go out of screen bounds
            };
}

UIWindow* _adsWindow;

#pragma Gamepad

- (void)_GamePadViewDidAppear:(__unused BOOL)animated {
    _gamepadViewController = [[GamePadViewController alloc] init];
    [self.view addSubview:_gamepadViewController.view];
    [self updateFrame];

    for (NSString* notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
        [[NSNotificationCenter defaultCenter]
                               addObserver:self selector:@selector(updateFrame)
                                                name:notification object:nil];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updateBannerWindow];
    [self updateFrame];
}

- (void)updateFrame {
    CGRect viewFrame = self.view.frame;
    CGFloat viewHeight = viewFrame.size.height;
    CGRect frame = [_gamepadViewController.view frame];
    frame.origin.x = frame.origin.y = 0;
    frame.size.height = viewHeight - self.keyboardHeight - kGADAdSizeBanner
            .size.height;  // because of the overflow
    frame.size.width = viewFrame.size.width;
    [_gamepadViewController.view setFrame:frame];
}

GamePadViewController* _gamepadViewController;
@dynamic keyboardHeight;

@end