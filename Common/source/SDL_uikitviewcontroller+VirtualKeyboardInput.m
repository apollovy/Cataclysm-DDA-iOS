//
//  SDL_uikitviewcontroller+VirtualKeyboardInput.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 02/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include "SDL_events.h"

#include "SDL_char_utils.h"

#import "SDL_uikitviewcontroller+VirtualKeyboardInput.h"

@implementation SDL_uikitviewcontroller (VirtualKeyboardInput)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    SDL_Event sdlDownEvent = {};

    if((range.location == 63) && (range.length == 1) && (string.length == 0))
    // backspace pressed
    {
        sdlDownEvent.type = SDL_KEYDOWN;
        sdlDownEvent.key.keysym.sym = '\b';
    }
    else if([string isEqualToString:@"\n"]) {
        sdlDownEvent.type = SDL_KEYDOWN;
        sdlDownEvent.key.keysym.scancode = SDL_SCANCODE_RETURN;
    }
    else {
        sdlDownEvent = SDL_write_text_to_event(sdlDownEvent, string);
    }
    SDL_PushEvent(&sdlDownEvent);

    return NO;
}

@end
