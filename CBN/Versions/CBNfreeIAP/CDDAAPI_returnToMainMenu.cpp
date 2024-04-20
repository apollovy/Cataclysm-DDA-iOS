//
//  CDDAAPI.cpp
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 17.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#include <stdio.h>

#include "event.h"
#import "event_bus.h"
#import "avatar.h"
#import "game.h"

extern "C"
{
void CDDAAPI_returnToMainMenu()
{
    g->save(true);
    g->uquit = QUIT_SAVED;
//    g->moves_since_last_save++;
}
}
