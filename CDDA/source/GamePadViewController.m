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

-(void)viewDidLoad
{
    [super viewDidLoad];
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
    
    [self.escapeButton.titleLabel setText:@"ESC"];
    [self.returnButton.titleLabel setText:@"⮐"];
    [self.tabButton.titleLabel setText:@"⇥"];

    for (id button in @[self.escapeButton, self.returnButton, self.tabButton])
    {
        [button setBackgroundImage:[UIImage imageNamed:@"button"]];
        [button setBackgroundImagePressed:[UIImage imageNamed:@"button-pressed"]];
    }
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

#pragma mark - JSDButtonDelegate

BOOL pressed;

- (void)buttonPressed:(JSButton *)button
{
    if (!pressed)
    {
        pressed = YES;
        SDL_Keycode sym;
        if (button == self.escapeButton)
            sym = SDLK_ESCAPE;
        else if (button == self.tabButton)
            sym = SDLK_TAB;
        else if (button == self.returnButton)
            sym = SDLK_RETURN;
        else
        {
            NSLog(@"Unknown button pressed: %@", button);
            return;
        }
        SDL_Event event = {.type=SDL_KEYDOWN};
        event.key.keysym.sym = sym;
        SDL_PushEvent(&event);
    }
}

- (void)buttonReleased:(JSButton *)button
{
    pressed = NO;
}

@end
