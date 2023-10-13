#include <Foundation/Foundation.h>

#include "CDDA_main.h"

#include <UIKit/UIKit.h>
#include "MainViewController.h"
#import "getCataclysmFlavor.h"

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
    catacurses::endwin();
}

extern "C"
{
#include "cdda_firebase.h"
#import "subscribeDisplayingPaywallToCDDAEvents.h"
#import "displayInitialPaywall.h"
#import "PaywallUnlimitedFunctionality.h"

void repeatTryingToSubscribeDisplayingPaywallToCDDAEventsUntilSucceeds(int attempt=1) {
    dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
            dispatch_get_main_queue(),
            ^{
                NSLog(@"Trying to subscribe to events with %i attempt.",
                        attempt);
                if (!subscribeDisplayingPaywallToCDDAEvents()) {
                    repeatTryingToSubscribeDisplayingPaywallToCDDAEventsUntilSucceeds(attempt + 1);
                };
            }
    );
}

int CDDA_iOS_main(NSString* documentPath) {
    configureFirebase();
    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    NSString* pathInFramework = [NSString stringWithFormat:@"/%@Framework.framework/", getCataclysmFlavor()];
    NSString* frameworkRootDir = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingString:pathInFramework];
    [NSFileManager.defaultManager changeCurrentDirectoryPath:frameworkRootDir];
    NSArray<NSString*>* newArguments = [arguments arrayByAddingObjectsFromArray:@[
        @"--datadir", [frameworkRootDir stringByAppendingString:@"data/"],
        @"--userdir", [documentPath stringByAppendingString:@"/"],
        
    ]];
    int newArgumentsCount = static_cast<int>(newArguments.count);
    char** stringArgs = cArrayFromNSArray(newArguments);
    
    if (!isUnlimitedFunctionalityUnlocked()) {
        repeatTryingToSubscribeDisplayingPaywallToCDDAEventsUntilSucceeds();
    }
    
    int exitCode = CDDA_main(newArgumentsCount, stringArgs);
 
    return exitCode;
}


}
