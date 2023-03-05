//
// Created by Аполлов Юрий Андреевич on 17.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import "SDL_uikitviewcontroller.h"

@interface SDL_uikitviewcontroller (Gamepad)

@property (nonatomic, assign) int keyboardHeight;

- (void)maybeUpdateFrameTo:(CGSize)size;
- (void)resizeRootView;

@end
