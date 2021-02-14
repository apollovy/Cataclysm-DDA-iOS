#import <__wctype.h>
//
// Created by Аполлов Юрий Андреевич on 17.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

@import CoreGraphics;

#import "SDL_uikitviewcontroller+Gamepad.h"
#import "GamePadViewController.h"


#pragma mark - OnKeyboardHandler

@interface OnKeyboardHandler : NSObject

@property (weak, nonatomic) SDL_uikitviewcontroller* _controller;

@end

@implementation OnKeyboardHandler

+(id)initWithController:(SDL_uikitviewcontroller*)controller
{
    OnKeyboardHandler* obj = [OnKeyboardHandler new];
    obj._controller = controller;
    
    return obj;
}

-(void)onKeyboard
{
    CGSize size = self._controller.view.window.frame.size;
    size.height = size.height - self._controller.keyboardHeight;
    [self._controller maybeUpdateFrameTo:size];
}

@end


#pragma mark - SDL_uikitviewcontroller (Gamepad)

@implementation SDL_uikitviewcontroller (Gamepad)

- (void)viewDidAppear:(BOOL)animated {
    NSDictionary* appDefaults = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"overlayUIEnabled"];
    [NSUserDefaults.standardUserDefaults registerDefaults:appDefaults];

    for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification, UIApplicationDidBecomeActiveNotification, UIApplicationWillResignActiveNotification])
        [self registerNotification:notification forSelector:@selector(resizeRootView)];
    [self registerNotification:NSUserDefaultsDidChangeNotification forSelector:@selector(maybeToggleUI)];

    [self resizeRootView];
    [self maybeToggleUI];
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

- (void)maybeToggleUI
{
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"overlayUIEnabled"])
    {
        _gamepadViewController = [[UIStoryboard storyboardWithName:@"UIControls" bundle:nil] instantiateInitialViewController];
        [self.view addSubview:_gamepadViewController.view];

        _onKeyboardHandler = [OnKeyboardHandler initWithController:self];
        for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
            [[NSNotificationCenter defaultCenter] addObserver:_onKeyboardHandler selector:@selector(onKeyboard) name:notification object:nil];
        }
    } else {
        [self hideKeyboard];
        [_gamepadViewController.view removeFromSuperview];
        _gamepadViewController = nil;
        for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
            [[NSNotificationCenter defaultCenter] removeObserver:_onKeyboardHandler name:notification object:nil];
        }
        _onKeyboardHandler = nil;
    }
}

OnKeyboardHandler* _onKeyboardHandler;

- (void)registerNotification:(NSNotificationName)notification forSelector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notification object:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self maybeUpdateFrameTo:size];
}

- (void)maybeUpdateFrameTo:(CGSize)size {
    if (_gamepadViewController)
    {
        CGRect frame = _gamepadViewController.view.frame;
        frame.size = size;
        _gamepadViewController.view.frame = frame;
    }
}

GamePadViewController* _gamepadViewController;
@dynamic keyboardHeight;

@end


