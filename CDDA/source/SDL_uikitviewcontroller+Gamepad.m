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
    [self updateFrame];

    for (NSString* notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(updateFrame)
         name:notification object:nil];
    }
}

- (void)resizeRootView
{
    if (@available(iOS 11.0, *)) {
        UIView* view = self.view;
        UIEdgeInsets insets = view.safeAreaInsets;
        CGRect viewFrame = view.frame;
        viewFrame.origin.x = insets.left;
        viewFrame.size.width = viewFrame.size.width - insets.right - insets.left;
        view.frame = viewFrame;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
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
