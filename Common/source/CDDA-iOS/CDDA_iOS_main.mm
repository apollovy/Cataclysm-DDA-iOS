#include <Foundation/Foundation.h>

#include "CDDA_main.h"

#include <UIKit/UIKit.h>
#include "MainViewController.h"
#import "getCataclysmFlavor.h"
#import "getCDDARunArgs.h"


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
    if (!isUnlimitedFunctionalityUnlocked()) {
        repeatTryingToSubscribeDisplayingPaywallToCDDAEventsUntilSucceeds();
    }
    auto cDDARunArgs = getCDDARunArgs(documentPath);
    int exitCode = CDDA_main(std::get<0>(cDDARunArgs), std::get<1>(cDDARunArgs));
 
    return exitCode;
}


}
