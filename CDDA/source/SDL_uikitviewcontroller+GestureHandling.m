//
//  SDL_uikitviewcontroller+GestureHandling.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 02/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include <UIKit/UIKit.h>

#import <objc/runtime.h>

#import "SDL_uikitviewcontroller+GestureHandling.h"

/*
 We use Method Swizzling because it hard enough to substitute SDL_uikitviewcontroller in appropriate places.
*/
@implementation SDL_uikitviewcontroller (GestureHandling)


- (void)modifiedSetView:(UIView *)view
{
    [self modifiedSetView:view];

    UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [view addGestureRecognizer:swipeUpRecognizer];

    UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [view addGestureRecognizer:swipeDownRecognizer];
}

+(void)load
{
    Method originalSetView = class_getInstanceMethod(self, @selector(setView:));
    Method modifiedSetView = class_getInstanceMethod(self, @selector(modifiedSetView:));
    method_exchangeImplementations(originalSetView, modifiedSetView);
}

@end
