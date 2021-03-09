//
//  ViewController.m
//  SDLPlayground2
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "SDL.h"
#import <Foundation/Foundation.h>

#import "CDDA_iOS_main.h"

#import "ViewController.h"


@implementation ViewController

- (IBAction)startApp:(id)sender
{
    self.view.window.hidden = YES;
    self.view = nil;
    SDL_iPhoneSetEventPump(SDL_TRUE);
    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    int arguments_count = NSProcessInfo.processInfo.arguments.count;
    char* args[arguments_count];
    
    for(int i=0; i<arguments_count; i++)
        args[i] = [arguments[i] UTF8String];
    CDDA_iOS_main(NSProcessInfo.processInfo.arguments.count, args);
    SDL_iPhoneSetEventPump(SDL_FALSE);
}

@end
