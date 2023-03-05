//
//  SDL_char_utils.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 28.01.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#ifdef __cplusplus
extern "C" {
#endif


#import "SDL_events.h"

#import <Foundation/Foundation.h>

#ifndef SDL_char_utils_h
#define SDL_char_utils_h

SDL_Event SDL_write_text_to_event(SDL_Event event, NSString* text);
void SDL_send_text_event(NSString* text);
void SDL_send_keysym(SDL_KeyCode key, SDL_Keymod mods);
void SDL_send_keysym_or_text(SDL_KeyCode sym, SDL_Keymod mods, NSString* text);

#endif /* SDL_char_utils */
#ifdef __cplusplus
}
#endif
