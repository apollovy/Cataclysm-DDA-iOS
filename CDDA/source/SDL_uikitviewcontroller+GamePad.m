//
//  SDL_uikitviewcontroller+GamePad.m
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL_uikitviewcontroller.h"

#import "GamePadViewController.h"



@implementation SDL_uikitviewcontroller (GamePad)


- (void)viewWillAppear:(BOOL)animated
{
    _gamepadViewController = [[GamePadViewController alloc] init];
    [self.view addSubview:_gamepadViewController.view];
    [self updateFrame];
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
    frame.origin.x = 20;
    frame.origin.y = screenHeight - 20 - frame.size.height;
    [_gamepadViewController.view setFrame:frame];
}

GamePadViewController* _gamepadViewController;

@end
