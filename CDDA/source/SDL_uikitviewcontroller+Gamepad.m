#import <__wctype.h>
//
// Created by Аполлов Юрий Андреевич on 17.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

@import CoreGraphics;

#import "SDL_uikitviewcontroller+Gamepad.h"
#import "GamePadViewController.h"

@implementation SDL_uikitviewcontroller (Gamepad)

- (void)viewDidAppear:(BOOL)animated {
    [self resizeRootView];
    _gamepadViewController = [
                              [UIStoryboard storyboardWithName:@"UIControls" bundle:nil]
                              instantiateInitialViewController];
    [self.view addSubview:_gamepadViewController.view];

    for (NSString* notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(updateFrame)
         name:notification object:nil];
    }
    for (NSString* notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification, UIApplicationDidBecomeActiveNotification, UIApplicationWillResignActiveNotification]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(resizeRootView)
         name:notification object:nil];
    }
}

- (void)resizeRootView
{
    if (@available(iOS 11.0, *)) {
        UIView* view = self.view;
        UIWindow* window = UIApplication.sharedApplication.keyWindow;
        UIEdgeInsets insets = window.safeAreaInsets;

        CGRect viewFrame = view.frame;
        viewFrame.origin.x = viewFrame.origin.x + insets.left;
        viewFrame.size.width = viewFrame.size.width - insets.right - insets.left;
        view.frame = viewFrame;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self updateFrame];
}

- (void)updateFrame {
    CGRect windowFrame = self.view.window.frame;
    CGRect frame = _gamepadViewController.view.frame;
    frame.origin.y = 0;
    frame.size.height = windowFrame.size.height - self.keyboardHeight;
    _gamepadViewController.view.frame = frame;
}

GamePadViewController* _gamepadViewController;
@dynamic keyboardHeight;

@end
