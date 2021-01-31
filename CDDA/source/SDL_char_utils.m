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

void SDL_send_keysym(SDL_KeyCode sym, SDL_Keymod mods)
{
    SDL_Event event = {.type = SDL_KEYDOWN};
    event.key.keysym.sym = sym;
    event.key.keysym.mod = mods;
    SDL_PushEvent(&event);
}

void SDL_send_keysym_or_text(SDL_KeyCode sym, SDL_Keymod mods, NSString* text)
{
    if (sym && text)
        NSLog(@"Both sym (%d) and text (%s) provided, using sym", sym, [text UTF8String]);
    if (sym) {  // special symbols
        SDL_send_keysym(sym, mods);
    } else {  // regular symbols
        SDL_send_text_event(text);
    }
}
