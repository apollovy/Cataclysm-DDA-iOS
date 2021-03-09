#include <Foundation/Foundation.h>

#define main CDDA_main
#include "main.cpp"
#undef main

#include "SDL.h"

extern "C"
{

int CDDA_iOS_main(NSString* documentPath)
{
    SDL_iPhoneSetEventPump(SDL_TRUE);

    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    int arguments_count = NSProcessInfo.processInfo.arguments.count;
    char* args[arguments_count];
    
    for(int i=0; i<arguments_count; i++)
        strcpy(args[i], [arguments[i] UTF8String]);

    NSString* datadir = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/data/"];
    const char* new_argv_const[] = {
        *args,
        "--datadir", [datadir UTF8String],
        "--userdir", [documentPath UTF8String],
    };
    const int new_argv_const_size = (sizeof(new_argv_const) / sizeof(*new_argv_const));
    char* new_argv[new_argv_const_size];
    
    for (int i=0; i<(new_argv_const_size); i++) {
        auto arg_ptr = new_argv_const[i];
        auto new_ptr = new char[strlen(arg_ptr)];
        new_argv[i] = strcpy(new_ptr, arg_ptr);
    };

    int exitCode = CDDA_main(new_argv_const_size, new_argv);
    SDL_iPhoneSetEventPump(SDL_FALSE);

    return exitCode;
}

}
