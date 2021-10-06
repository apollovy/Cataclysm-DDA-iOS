#include <Foundation/Foundation.h>

#define main CDDA_main

void no_exit(int status){}
#define exit no_exit
#include "runtime_handlers.h"
#include "main.cpp"
#undef main

#include "SDL.h"

#include <UIKit/UIKit.h>
#include "MainViewController.h"

// https://stackoverflow.com/a/15318065/674557
char** cArrayFromNSArray(NSArray* array)
{
    int i, count = array.count;
    char** cargs = (char**) malloc(sizeof(char*) * (count + 1));
    for(i = 0; i < count; i++) {
        NSString *s = array[i];
        const char *cstr = s.UTF8String;
        int len = strlen(cstr);
        char* cstr_copy = (char*) malloc(sizeof(char) * (len + 1));
        strcpy(cstr_copy, cstr);
        cargs[i] = cstr_copy;
    }
    cargs[i] = NULL;
    return cargs;
}

void exit_handler( int status )
{
    deinitDebug();
    g.reset();
    catacurses::endwin();
}

extern "C"
{

int CDDA_iOS_main(NSString* documentPath)
{
    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    NSString* datadir = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/data/"];
    NSArray<NSString*>* newArguments = [arguments arrayByAddingObjectsFromArray:@[
        @"--datadir", datadir,
        @"--userdir", [documentPath stringByAppendingString:@"/"],
        
    ]];
    int newArgumentsCount = newArguments.count;
    char** stringArgs = cArrayFromNSArray(newArguments);
    
    SDL_iPhoneSetEventPump(SDL_TRUE);
    int exitCode = CDDA_main(newArgumentsCount, stringArgs);
    SDL_iPhoneSetEventPump(SDL_FALSE);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
        auto window = [[UIApplication.sharedApplication windows] firstObject];
        window.rootViewController = vc;
        [window makeKeyAndVisible];
    });
    
    return exitCode;
}


}
