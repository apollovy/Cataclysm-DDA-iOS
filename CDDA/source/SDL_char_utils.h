//
//  SDL_char_utils.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 28.01.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL_events.h"

@import Foundation;

#ifndef SDL_char_utils_h
#define SDL_char_utils_h

SDL_Event SDL_write_text_to_event(SDL_Event event, NSString* text);
void SDL_send_text_event(NSString* text);

#endif /* SDL_char_utils */
