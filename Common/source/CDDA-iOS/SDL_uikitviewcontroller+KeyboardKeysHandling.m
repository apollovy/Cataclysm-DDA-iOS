//
//  SDL_uikitviewcontroller+KeyboardTest.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 01/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#include "SDL_events.h"

#include "SDL_uikitviewcontroller+KeyboardKeysHandling.h"

#include "SDL_char_utils.h"


@implementation SDL_uikitviewcontroller (KeyboardKeysHandling)
NSDictionary* _keyCommandsTranslator;


- (NSArray *)keyCommands {
    _keyCommandsTranslator = @{UIKeyInputUpArrow: @"UP",
                               UIKeyInputDownArrow: @"DOWN",
                               UIKeyInputLeftArrow: @"LEFT",
                               UIKeyInputRightArrow: @"RIGHT",
                               UIKeyInputEscape: @"\033"};
    const NSArray* characterLists = [
        NSArray arrayWithObjects:
        // common on Macbook keyboard
        @"§-=",  // putting backspace in this list makes it behave badly
        @"\t[]\r",
        @";'\\",
        @"`,./",
        // shifted on Macbook keyboard
        @"±!@#$%^&*()_+",
        @"{}",
        @":\"|",
        @"~<>?",
        @" ",
        nil
    ];

    
    NSMutableArray* keys = [[NSMutableArray alloc] init];
    
    for (NSString* characterList in characterLists)
    {
        for (NSUInteger i=0; i<[characterList length]; i++)
        {
            [keys addObject:[NSString stringWithFormat:@"%C", [characterList characterAtIndex:i]]];
        }
    }
    
    NSMutableArray* _commands = [[NSMutableArray alloc] init];
    
    for(char i = 'a'; i <= 'z'; i++) {
        NSString *key = [NSString stringWithFormat:@"%c", i];
        [_commands addObject:[UIKeyCommand keyCommandWithInput:key modifierFlags:0 action:@selector(handleCommand:)]];
        [_commands addObject:[UIKeyCommand keyCommandWithInput:key modifierFlags:UIKeyModifierShift action:@selector(handleCommand:)]];
    }
    
    for(char i = '0'; i <= '9'; i++) {
        NSString *key = [NSString stringWithFormat:@"%c", i];
        [_commands addObject:[UIKeyCommand keyCommandWithInput:key modifierFlags:0 action:@selector(handleCommand:)]];
    }
    
    for(id key in keys) {
        [_commands addObject:[UIKeyCommand keyCommandWithInput:key modifierFlags:0 action:@selector(handleCommand:)]];
    }
    
    for(NSString *key in _keyCommandsTranslator) {
        [_commands addObject:[UIKeyCommand keyCommandWithInput:key modifierFlags:0 action:@selector(handleCommand:)]];
        [_commands addObject:[UIKeyCommand keyCommandWithInput:key modifierFlags:UIKeyModifierShift action:@selector(handleCommand:)]];
    }
    return _commands;
}

- (void)handleCommand:(UIKeyCommand *)keyCommand {
    NSString *key;

    if(keyCommand.modifierFlags == UIKeyModifierShift) {
        if([keyCommand.input length] == 1
           && [keyCommand.input characterAtIndex:0] >= 'a'
           && [keyCommand.input characterAtIndex:0] <= 'z') {
            key = [keyCommand.input uppercaseString];
        }
    } else {
        key = [_keyCommandsTranslator objectForKey:keyCommand.input];
        if(key == nil) {
            key = keyCommand.input;
        }
    }

    if(key) {
        NSSet* specialKeys = [NSSet setWithArray:[[_keyCommandsTranslator
                allValues] arrayByAddingObjectsFromArray:@[@"\r", @"\t"]]];
        SDL_Event event = {};
        if ([specialKeys containsObject:key]) {
            SDL_KeyCode keyCode = SDL_GetKeyFromName([key UTF8String]);
            event.type = SDL_KEYDOWN;
            event.key.keysym.sym = keyCode;
        } else {
            event = SDL_write_text_to_event(event, key);
        }
        SDL_PushEvent(&event);
    }
}
@end
