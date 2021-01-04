//
//  SDL_uikitviewcontroller+GestureHandling.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 02/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include <UIKit/UIKit.h>

#import <objc/runtime.h>

#import "SDL_events.h"
#import "SDL_rect.h"

#import "SDL_uikitviewcontroller+GestureHandling.h"

/*
 We use Method Swizzling because it hard enough to substitute SDL_uikitviewcontroller in appropriate places.
*/
@implementation SDL_uikitviewcontroller (GestureHandling)


- (void)modifiedSetView:(UIView *)view
{
    [self modifiedSetView:view];

    for (NSNotificationName notification in @[UIKeyboardDidShowNotification, UIKeyboardDidHideNotification])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeCDDAWindow:) name:notification object:nil];
    }
    
    UISwipeGestureRecognizer* swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyboard)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [view addGestureRecognizer:swipeUpRecognizer];

    UISwipeGestureRecognizer* swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [view addGestureRecognizer:swipeDownRecognizer];
}

-(void)resizeCDDAWindow:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSValue* keyboardFrame = [userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRectangle = [keyboardFrame CGRectValue];
    
    CGSize windowSize = {self.view.window.frame.size.width, keyboardRectangle.origin.y};
    self.view.window.frame = (CGRect){.origin.x=0, .origin.y=0, windowSize};

    SDL_Event event = {
        .window={
            .event=SDL_WINDOWEVENT_RESIZED,
            .data1=self.view.window.bounds.size.width,
            .data2=keyboardRectangle.origin.y,
        },
    };
    event.type=SDL_WINDOWEVENT;
    SDL_PushEvent(&event);  // FIXME: Calling this stuff in main menu ruins the app, because it feels it has not enough space. Same applies to no-tiles mode.
}

+(void)load
{
    Method originalSetView = class_getInstanceMethod(self, @selector(setView:));
    Method modifiedSetView = class_getInstanceMethod(self, @selector(modifiedSetView:));
    method_exchangeImplementations(originalSetView, modifiedSetView);
}

@end
