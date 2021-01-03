//
//  GamePadViewController.m
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL_events.h"

#import "JSDPad.h"

#import "GamePadViewController.h"


@implementation GamePadViewController


NSMutableDictionary <NSNumber*, NSString*>* directionsToStrings;

-(id)init
{
    self = [super init];
    JSDPadDirection dirs[] = {
        JSDPadDirectionUp,
        JSDPadDirectionDown,
        JSDPadDirectionLeft,
        JSDPadDirectionRight,
        JSDPadDirectionUpLeft,
        JSDPadDirectionUpRight,
        JSDPadDirectionDownLeft,
        JSDPadDirectionDownRight,
        JSDPadDirectionNone,
    };
    const char keyCodes[] = "kjhlyubn.";
    int directionsCount = sizeof(dirs) / sizeof(dirs[0]);
    directionsToStrings = [NSMutableDictionary dictionary];
    for (int i=0; i<directionsCount; i++)
    {
        char key;
        key = keyCodes[i];
        NSString* keyString = [NSString stringWithUTF8String:&key];
        NSNumber* dirInt = [NSNumber numberWithInt:dirs[i]];
        [directionsToStrings setObject:keyString forKey:dirInt];
    }
    return self;
}


#pragma mark - JSDPadDelegate

- (void)dPad:(JSDPad *)dPad didPressDirection:(JSDPadDirection)direction
{
    NSString* key = [directionsToStrings objectForKey:[NSNumber numberWithInt:direction]];
    // TODO: refactor this, it is slmost the same as in +KeyboardKeysHandling.m
    SDL_Event event;
    event.text.type = SDL_TEXTINPUT;
    SDL_utf8strlcpy(event.text.text, [key UTF8String], SDL_arraysize(event.text.text));
    SDL_PushEvent(&event);
}

@end
