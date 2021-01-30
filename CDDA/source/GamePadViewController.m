//
//  GamePadViewController.m
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL_events.h"

#import "JSDPad.h"
#import "JSButton.h"

#import "SDL_char_utils.h"
#import "GamePadViewController.h"


@implementation GamePadViewController


#pragma mark - JSDPadDelegate

- (void)dPad:(JSDPad *)dPad didPressDirection:(JSDPadDirection)direction
{
    SDL_Event event = {};
    switch (direction) {
        case JSDPadDirectionNone:
            break;
        case JSDPadDirectionUp:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_UP;
            break;
        case JSDPadDirectionDown:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_DOWN;
            break;
        case JSDPadDirectionLeft:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_LEFT;
            break;
        case JSDPadDirectionRight:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_RIGHT;
            break;
        case JSDPadDirectionUpLeft:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"7";
            break;
        case JSDPadDirectionUpRight:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"9";
            break;
        case JSDPadDirectionDownLeft:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"1";
            break;
        case JSDPadDirectionDownRight:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"3";
            break;
        default:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"5";
            break;
    }
    SDL_PushEvent(&event);
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

        SDL_Event event = {};

        if (sym) {  // special symbols
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = sym;
            event.key.keysym.mod = modifier;
        }
        else {  // regular symbols
            event = SDL_write_text_to_event(event, text);
        }
        SDL_PushEvent(&event);
    }
}

- (void)buttonReleased:(JSButton *)button
{
    pressed = NO;
}

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
    [UIView animateWithDuration:0.4 animations:^{
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

@end
