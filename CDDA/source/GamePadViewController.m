//
//  GamePadViewController.m
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL_events.h"
#include "SDL_uikitviewcontroller.h"

#import "JSButton.h"

#import "SDL_char_utils.h"
#import "GamePadViewController.h"


@implementation GamePadViewController

- (void)viewDidAppear:(BOOL)animated
{
    UIWindow* window = self.view.window;
    CGRect windowFrame = window.rootViewController.view.frame;
    CGRect viewControllerFrame = self.view.frame;
    viewControllerFrame.origin.x = -windowFrame.origin.x;
    viewControllerFrame.size.width = window.screen.bounds.size.width;
    self.view.frame = viewControllerFrame;
}

#pragma mark - JSDButtonDelegate

BOOL pressed;

- (void)buttonPressed:(JSButton *)button
{
    if (!pressed)
    {
        pressed = YES;

        NSString* text = [(UILabel*)[button.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            return [evaluatedObject respondsToSelector:@selector(text)];
        }]].firstObject text];
        
        if (!text.length)
        {
            NSLog(@"Unknown button pressed: %@", button);
            return;
        }
        
        SDL_Keycode sym = SDLK_UNKNOWN;
        SDL_Keymod modifier = KMOD_NONE;
        
        // special symbols
        if ([text  isEqual: @"ESC"])
        {
            if (!self.menusView.hidden)
            {
                [self hideMenus:^(BOOL completed){
                    [self hideMenusView];
                }];
                return;
            }
            sym = SDLK_ESCAPE;
        }
        else if ([text isEqual:@"⮐"])
            sym = SDLK_RETURN;
        else if ([text isEqual:@"TAB"])
            sym = SDLK_TAB;
        else if ([text isEqual:@"BTAB"])
        {
            sym = SDLK_TAB;
            modifier = KMOD_SHIFT;
        }
        SDL_send_keysym_or_text(sym, modifier, text);
    }
}

- (void)buttonReleased:(JSButton *)button
{
    pressed = NO;
}


#pragma mark - Menus handling

-(void)toggleMenu:(MenuButton*)sender
{
    if (!sender.menuView)
    {
        NSLog(@"No menu associated with MenuButton %@", sender);
        return;
    }
    BOOL shouldBeVisible = sender.menuView.hidden;
    
    if (shouldBeVisible)
    {
        if (sender.menuView.alpha)  // this is initial state, views are visible to easily interact with them in UIBuilder
            sender.menuView.alpha = 0;
        self.menusView.hidden = NO;
        sender.menuView.hidden = NO;
        
        // hide all menus before showing one
        [self hideMenus:nil];

        [self toggleView:sender.menuView visibility:YES completion:nil];
    } else {
        [self toggleView:sender.menuView visibility:NO completion:^(BOOL finished){
            [self hideMenusView];
        }];
    }
}

-(void)hideMenus:(void (^)(BOOL finished))completion
{
    NSArray<UIView*>* menuViews = [[self menusView] subviews];

    for (UIView* menuView in menuViews)
        if (menuView.alpha)
            [self toggleView:menuView visibility:NO completion:completion];
}

-(void)hideMenusView
{
    self.menusView.hidden = YES;
}

-(void)toggleView:(UIView*)view visibility:(BOOL)shouldBeVisible completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.2 animations:^{
        view.alpha = shouldBeVisible;
    } completion:^(BOOL finished){
        view.hidden = !shouldBeVisible;
        if (completion)
            completion(finished);
    }];
}

-(void)pressKey:(MenuButton*)sender
{
    [self toggleMenu:sender];
    NSString* text = sender.currentTitle;
    NSString* firstSymbol = [text substringToIndex:1];
    SDL_send_text_event(firstSymbol);
}


#pragma mark - Zoom handling

NSDate* lastZoom;

-(void)zoom:(UIPinchGestureRecognizer*)sender
{
    NSDate* now = [NSDate date];
    if (!lastZoom || ([[lastZoom dateByAddingTimeInterval:0.5] compare:now] == kCFCompareLessThan))
    {
        lastZoom = now;
        NSString* text;
        if (sender.scale > 1)
            text = @"z";
        else
            text = @"Z";
        sender.scale = 1;
        SDL_send_text_event(text);
    }
}


#pragma Gamepad buttons handling from recognizers

NSDate* lastPress;

-(void)holdGamepadButton:(UILongPressGestureRecognizer*)sender
{
    NSDate* now = [NSDate date];
    if (!lastPress || ([[lastPress dateByAddingTimeInterval:0.1] compare:now] == kCFCompareLessThan))
    {
        lastPress = now;
        [self _handleMovement:sender];
    }
}

-(void)tapGamepadButton:(UITapGestureRecognizer*)sender
{
    [self _handleMovement:sender];
}

- (void)_handleMovement:(UIGestureRecognizer * _Nonnull)sender {
    CGPoint touchLocation = [sender locationInView:sender.view];
    int buttonWidth = sender.view.bounds.size.width / 3;
    int buttonHeight = sender.view.bounds.size.height / 3;
    int columnNumber = ((int) touchLocation.x) / buttonWidth;
    int rowNumber = ((int) touchLocation.y) / buttonHeight;
    
    SDL_Keycode sym = SDLK_UNKNOWN;
    NSString* text;
    
    if (rowNumber == 0 && columnNumber == 0)
        text = @"7";
    else if (rowNumber == 0 && columnNumber == 1)
        sym = SDLK_UP;
    else if (rowNumber == 0 && columnNumber == 2)
        text = @"9";
    else if (rowNumber == 1 && columnNumber == 0)
        sym = SDLK_LEFT;
    else if (rowNumber == 1 && columnNumber == 1)
        text = @".";
    else if (rowNumber == 1 && columnNumber == 2)
        sym = SDLK_RIGHT;
    else if (rowNumber == 2 && columnNumber == 0)
        text = @"1";
    else if (rowNumber == 2 && columnNumber == 1)
        sym = SDLK_DOWN;
    else if (rowNumber == 2 && columnNumber == 2)
        text = @"3";
    else
    {
        NSLog(@"Unknown button pressed in row %d, column %d", rowNumber, columnNumber);
        return;
    }
    SDL_send_keysym_or_text(sym, KMOD_NONE, text);
}


#pragma mark - Page up / Page down

CGPoint lastScrollingLocation;
NSDate* lastScrollingDate;

-(void)pageUpDown:(UIPanGestureRecognizer*)sender
{
    CGPoint currentLocation = [sender translationInView:sender.view];

    if ((sender.state == UIGestureRecognizerStateChanged) || ( sender.state == UIGestureRecognizerStateEnded))
    {
        sender.view.alpha = 0.07;
        NSDate* now = [NSDate date];
        if (!lastScrollingDate || ([[lastScrollingDate dateByAddingTimeInterval:0.1] compare:now] == kCFCompareLessThan))
        {
            SDL_KeyCode sym = SDLK_UNKNOWN;
            if (lastScrollingLocation.y > currentLocation.y)
                sym = SDLK_PAGEDOWN;
            else
                sym = SDLK_PAGEUP;
            SDL_send_keysym(sym, KMOD_NONE);
            lastScrollingLocation = currentLocation;
            lastScrollingDate = now;
        }
    }
    if ((sender.state == UIGestureRecognizerStateCancelled) || ( sender.state == UIGestureRecognizerStateEnded))
    {
        sender.view.alpha = 0.02;
        lastScrollingLocation = CGPointZero;
    }
}


#pragma mark - Keyboard toggling

-(void)showKeyboard:(UIScreenEdgePanGestureRecognizer*)sender
{
        [[self _getRootViewController] showKeyboard];
}

-(void)hideKeyboard:(UIScreenEdgePanGestureRecognizer*)sender;
{
    [[self _getRootViewController] hideKeyboard];
}

-(SDL_uikitviewcontroller*)_getRootViewController
{
    return (SDL_uikitviewcontroller*)self.view.window.rootViewController;;
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (([gestureRecognizer class] == [UIPanGestureRecognizer class]) && ([otherGestureRecognizer class] == [UIScreenEdgePanGestureRecognizer class]))
        return YES;
    else
        return NO;
}

@end
