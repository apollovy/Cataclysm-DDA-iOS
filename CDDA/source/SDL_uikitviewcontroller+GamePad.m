//
//  SDL_uikitviewcontroller+GamePad.m
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL_uikitviewcontroller.h"

#import "GamePadViewController.h"


@interface SDL_uikitviewcontroller (GamePad)

@property (nonatomic, assign) int keyboardHeight;

@end


@implementation SDL_uikitviewcontroller (GamePad)


- (void)viewWillAppear:(BOOL)animated
{
    _gamepadViewController = [[GamePadViewController alloc] init];
    [self.view addSubview:_gamepadViewController.view];
    [self updateFrame];
    
    for (NSString* notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrame) name:notification object:nil];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateFrame];
}

- (void)updateFrame
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    CGRect frame = [_gamepadViewController.view frame];
    frame.origin.x = frame.origin.y = 0;
    frame.size.height = screenHeight - self.keyboardHeight;
    frame.size.width = screenRect.size.width;
    [_gamepadViewController.view setFrame:frame];
}

GamePadViewController* _gamepadViewController;
@dynamic keyboardHeight;

@end
