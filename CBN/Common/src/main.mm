#include <Foundation/Foundation.h>

#define main CDDA_main

void no_exit(__attribute__((unused)) int status){}
#define exit no_exit
#include "runtime_handlers.h"
#include "../../worktree/Cataclysm-BN/src/main.cpp"
#undef main

#include <UIKit/UIKit.h>
#include "MainViewController.h"

// https://stackoverflow.com/a/15318065/674557
char** cArrayFromNSArray(NSArray* array)
{
    int i, count = static_cast<int>(array.count);
    char** cargs = (char**) malloc(sizeof(char*) * (count + 1));
    for(i = 0; i < count; i++) {
        NSString *s = array[static_cast<NSUInteger>(i)];
        const char *cstr = s.UTF8String;
        int len = static_cast<int>(strlen(cstr));
        char* cstr_copy = (char*) malloc(sizeof(char) * (len + 1));
        strcpy(cstr_copy, cstr);
        cargs[i] = cstr_copy;
    }
    cargs[i] = NULL;
    return cargs;
}

void exit_handler( __attribute__((unused)) int status )
{
    deinitDebug();
    g.reset();
    catacurses::endwin();
}

extern "C"
{
#include "cdda_firebase.h"
#import "subscribeDisplayingPaywallToCDDAEvents.h"

void subscribeSoon(int attempt=1) {
    dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
            dispatch_get_main_queue(),
            ^{
                NSLog(@"Trying to subscribe to events with %i attempt.",
                        attempt);
                if (!subscribeDisplayingPaywallToCDDAEvents()) {
                    subscribeSoon(attempt + 1);
                };
            }
    );
}

int CDDA_iOS_main(NSString* documentPath) {
    configureFirebase();
    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    NSString* datadir = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/data/"];
    NSArray<NSString*>* newArguments = [arguments arrayByAddingObjectsFromArray:@[
        @"--datadir", datadir,
        @"--userdir", [documentPath stringByAppendingString:@"/"],
        
    ]];
    int newArgumentsCount = static_cast<int>(newArguments.count);
    char** stringArgs = cArrayFromNSArray(newArguments);
    
    SDL_iPhoneSetEventPump(SDL_TRUE);
    subscribeSoon();
    int exitCode = CDDA_main(newArgumentsCount, stringArgs);
    SDL_iPhoneSetEventPump(SDL_FALSE);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MainViewController* vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        auto window = [[UIApplication.sharedApplication windows] firstObject];
#pragma clang diagnostic pop
        window.rootViewController = vc;
        [window makeKeyAndVisible];
    });
    
    return exitCode;
}


}
