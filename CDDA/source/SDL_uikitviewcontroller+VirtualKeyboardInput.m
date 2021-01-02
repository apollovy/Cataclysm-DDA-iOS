//
//  SDL_uikitviewcontroller+VirtualKeyboardInput.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 02/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include "SDL_events.h"

#import "SDL_uikitviewcontroller+VirtualKeyboardInput.h"

@implementation SDL_uikitviewcontroller (VirtualKeyboardInput)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    SDL_Event sdlDownEvent = {};

    if([string isEqualToString:@"\b"])  {
        sdlDownEvent.type = SDL_KEYDOWN;
        sdlDownEvent.key.keysym.scancode = SDL_SCANCODE_BACKSPACE;
    }
    else if([string isEqualToString:@"\n"]) {
        sdlDownEvent.type = SDL_KEYDOWN;
        sdlDownEvent.key.keysym.scancode = SDL_SCANCODE_RETURN;
    }
    else {
        sdlDownEvent.text.type = SDL_TEXTINPUT;
        SDL_utf8strlcpy(sdlDownEvent.text.text, [string UTF8String], SDL_arraysize(sdlDownEvent.text.text));
    }
    SDL_PushEvent(&sdlDownEvent);

    return NO;
}

@end
