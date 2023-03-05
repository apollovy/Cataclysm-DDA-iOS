//
//  SDL_uikitview+CDDA.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 07.02.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import "SDL_uikitview+CDDA.h"

@implementation SDL_uikitview (CDDA)

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    return YES;
}

@end
