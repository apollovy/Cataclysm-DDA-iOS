//
//  SDL_uikitviewcontroller+MainView.mm
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 22.12.2022.
//  Copyright © 2022 Аполлов Юрий Андреевич. All rights reserved.
//
#import "avatar.h"
#import "game.h"

#import "SDL_uikitviewcontroller+MainView.h"

extern "C" {
#import "SDL_char_utils.h"
}

@implementation SDL_uikitviewcontroller (MainView)
-(IBAction)showMain:(UIStoryboardSegue*)segue {
    if (g != NULL) {
        g->save();
        g->uquit = QUIT_SAVED;
        g->u.action_taken();
        // a trick to call a menu and then close the menu, so the game will get we've saved and
        // return to main screen.
        SDL_send_keysym(SDLK_ESCAPE, KMOD_NONE);
        dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
                dispatch_get_main_queue(),
                ^{
                    SDL_send_keysym(SDLK_ESCAPE, KMOD_NONE);
                }
        );
    } else {
        NSLog(@"No game to save while returning to main screen!");
    }
}
@end
