//
//  SDL_uikitviewcontroller+KeyboardTest.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 01/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include "SDL_uikitviewcontroller.h"



NS_ASSUME_NONNULL_BEGIN

@interface SDL_uikitviewcontroller (KeyboardKeysHandling)
- (NSArray *)keyCommands;
- (void)handleCommand:(UIKeyCommand *)keyCommand;
@end

NS_ASSUME_NONNULL_END
