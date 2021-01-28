//
//  GamePadViewController.m
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL_events.h"

#import "JSDPad.h"

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
            sym = SDLK_ESCAPE;
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
            event.text.type = SDL_TEXTINPUT;
            SDL_utf8strlcpy(event.text.text, [text UTF8String], SDL_arraysize(event.text.text));
        }
        SDL_PushEvent(&event);
    }
}

- (void)buttonReleased:(JSButton *)button
{
    pressed = NO;
}

@end
