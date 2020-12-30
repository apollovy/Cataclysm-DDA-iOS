#include <Foundation/Foundation.h>

#define main CDDA_main
#include "main.cpp"
#undef main
#include "SDL_main.h"

int main( int argc, char *argv[] )
{
    NSString* documentPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingString:@"/save/"];
    NSString* datadir = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/data/"];
    const char* new_argv[] = {
        *argv,
        "--datadir", [datadir cStringUsingEncoding:NSUTF8StringEncoding],
        "--savedir", [documentPath cStringUsingEncoding:NSUTF8StringEncoding],
    };

    return CDDA_main(5, new_argv);
}
