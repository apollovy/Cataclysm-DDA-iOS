#include <Foundation/Foundation.h>

#define main CDDA_main
#include "main.cpp"
#undef main
#include "SDL_main.h"

int main( int argc, char *argv[] )
{
    NSString* documentPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingString:@"/"];
    NSString* datadir = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/data/"];
    const char* new_argv_const[] = {
        *argv,
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
    
    return CDDA_main(new_argv_const_size, new_argv);
}
