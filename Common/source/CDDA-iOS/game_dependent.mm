//
//  game_dependent.m
//  dcss
//
//  Created by Аполлов Юрий Андреевич on 02.07.2022.
//

#import <Foundation/Foundation.h>
#import "SDL_char_utils.h"
#import "game_dependent.h"

void zoom(bool in)
{
    SDL_send_text_event(in ? @"z" : @"Z");
}
