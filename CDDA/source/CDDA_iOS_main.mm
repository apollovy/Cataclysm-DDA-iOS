#include <Foundation/Foundation.h>

#define main CDDA_main
#include "main.cpp"
#undef main

#include "SDL.h"

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

    return exitCode;
}

}
