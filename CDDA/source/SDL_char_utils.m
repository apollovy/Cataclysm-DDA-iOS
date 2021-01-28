//
//  SDL_char_utils.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 28.01.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include "SDL_char_utils.h"


SDL_Event SDL_write_text_to_event(SDL_Event event, NSString* text)
{
    event.text.type = SDL_TEXTINPUT;
    SDL_utf8strlcpy(event.text.text, [text UTF8String], SDL_arraysize(event.text.text));
    return event;
}

void SDL_send_text_event(NSString* text)
{
    SDL_Event event = {};
    event = SDL_write_text_to_event(event, text);
    SDL_PushEvent(&event);
}
