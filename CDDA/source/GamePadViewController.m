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


-(void)viewDidLoad
{
    [super viewDidLoad];

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
    SDL_Event event;
    switch (direction) {
        case JSDPadDirectionNone:
            break;
        case JSDPadDirectionUp:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_UP;
            break;
        case JSDPadDirectionDown:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_DOWN;
            break;
        case JSDPadDirectionLeft:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_LEFT;
            break;
        case JSDPadDirectionRight:
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = SDLK_RIGHT;
            break;
        case JSDPadDirectionUpLeft:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"7";
            break;
        case JSDPadDirectionUpRight:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"9";
            break;
        case JSDPadDirectionDownLeft:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"1";
            break;
        case JSDPadDirectionDownRight:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"3";
            break;
        default:
            event.type = SDL_TEXTINPUT;
            event.text.text[0] = *"5";
            break;
    }
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
