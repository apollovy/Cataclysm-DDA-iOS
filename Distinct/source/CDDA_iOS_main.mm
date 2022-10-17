#include <Foundation/Foundation.h>

#define main CDDA_main

void no_exit(int status){}
#define exit no_exit
#include "external/cdda/src/main.cpp"
#undef main

#include "SDL.h"

#include <UIKit/UIKit.h>
#include "MainViewController.h"

// https://stackoverflow.com/a/15318065/674557
const char** cArrayFromNSArray(NSArray<NSString*>* array)
{
    int i, count = array.count;
    const char** cargs = (const char**) malloc(sizeof(char*) * (count + 1));
    for(i = 0; i < count; i++) {
        cargs[i] = array[i].UTF8String;
    }
    cargs[i] = NULL;
    return cargs;
}

extern "C"
{

int CDDA_iOS_main(NSString* documentPath)
{
    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    NSString* basepath = [[NSBundle mainBundle] bundlePath];
    NSArray<NSString*>* newArguments = [arguments arrayByAddingObjectsFromArray:@[
        @"--basepath", basepath,
        @"--userdir", [documentPath stringByAppendingString:@"/"],
        
    ]];
    int newArgumentsCount = newArguments.count;
    const char** stringArgs = cArrayFromNSArray(newArguments);

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
