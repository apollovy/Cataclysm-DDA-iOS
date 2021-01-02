//
//  SDL_uikitviewcontroller+GestureHandling.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 02/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include <UIKit/UIKit.h>

#include "SDL_keyboard.h"

#import "SDL_uikitviewcontroller+GestureHandling.h"


@implementation SDL_uikitviewcontroller (GestureHandling)


// the right place is to do it in viewDidLoad, but since it's empty in SDL implementation, we cannot rely on it.
- (void)setView:(UIView *)view
{
    [super setView:view];

    UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [view addGestureRecognizer:swipeUpRecognizer];

    UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [view addGestureRecognizer:swipeDownRecognizer];
}

@end
