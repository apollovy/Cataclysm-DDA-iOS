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
        SDL_Event event = {};
        SDL_Keycode sym = SDLK_UNKNOWN;
        SDL_Keymod modifier = KMOD_NONE;
        
        // special symbols
        if (button == self.escapeButton)
            sym = SDLK_ESCAPE;
        else if (button == self.returnButton)
            sym = SDLK_RETURN;
        else if (button == self.tabButton)
            sym = SDLK_TAB;
        else if (button == self.backtabButton) {
            sym = SDLK_TAB;
            modifier = KMOD_SHIFT;
        }
        
        if (sym) {
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = sym;
            event.key.keysym.mod = modifier;
        }
        else { // letters
            event.text.type = SDL_TEXTINPUT;
            NSString* text = @"";
            
            // FIXME: this should be done using dict
            // small letters
            if (button == self.aButton)
                text = @"a";
            else if (button == self.cButton)
                text = @"c";
            else if (button == self.dButton)
                text = @"d";
            else if (button == self.eButton)
                text = @"e";
            else if (button == self.fButton)
                text = @"f";
            else if (button == self.iButton)
                text = @"i";
            else if (button == self.mButton)
                text = @"m";
            else if (button == self.rButton)
                text = @"r";
            else if (button == self.sButton)
                text = @"s";
            else if (button == self.tButton)
                text = @"t";
            else if (button == self.wButton)
                text = @"w";
            
            // punctuation
            else if (button == self.dotButton)
                text = @".";
            else if (button == self.slashButton)
                text = @"/";


            // digits
            else if (button == self._1Button)
                text = @"1";
            else if (button == self._2Button)
                text = @"2";
            else if (button == self._3Button)
                text = @"3";
            else if (button == self._4Button)
                text = @"4";
            else if (button == self._5Button)
                text = @"5";
            else if (button == self._6Button)
                text = @"6";
            else if (button == self._7Button)
                text = @"7";
            else if (button == self._8Button)
                text = @"8";
            else if (button == self._9Button)
                text = @"9";

            if (!text.length)
            {
                NSLog(@"Unknown button pressed: %@", button);
                return;
            }
            
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
