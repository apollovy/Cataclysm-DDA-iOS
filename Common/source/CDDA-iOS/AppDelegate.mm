//
//  AppDelegate.m
//  SDLPlayground2
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "AppDelegate.h"
#import "Sentry.h"
#import "getCataclysmFlavor.h"
#import "displayInitialPaywall.h"
#import "getCDDARunArgs.h"
#include "CDDA_main.h"
#include "CDDAAPI.h"
#import "PaywallDisplayEventSubscriberDelegate.h"
#import "DefaultPaywallDisplayEventSubscriberDelegate.h"
#import "ReturnToMainMenuPaywallCloseActionDelegate.h"

extern "C"
{
#import "path_utils.h"
#import "unFullScreen.h"
#include "cdda_firebase.h"
#import "PaywallUnlimitedFunctionality.h"
}

void repeatTryingToSubscribeDisplayingPaywallToCDDAEventsUntilSucceeds(id<PaywallDisplayEventSubscriberDelegate> delegate, int attempt=1) {
    dispatch_after(
                   dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC),
                   dispatch_get_main_queue(),
                   ^{
                       NSLog(@"Trying to subscribe to events with %i attempt.",
                             attempt);
                       auto subscription_f_ptr = CDDAAPI::subscribeDisplayingPaywallToCDDAEvents_ptr;
                       
                       if (subscription_f_ptr == NULL || !(*subscription_f_ptr)(delegate)) {
                           repeatTryingToSubscribeDisplayingPaywallToCDDAEventsUntilSucceeds(delegate, attempt + 1);
                       };
                   }
                   );
}

@implementation AppDelegate
{
    UIWindow* mainWindow;
}
+ (NSString *)getAppDelegateClassName
{
    return @"AppDelegate";
}
- (void)postFinishLaunch
{
    [self performSelector:@selector(hideLaunchScreen) withObject:nil afterDelay:0.0];

    if (self.launchWindow) {
        self.launchWindow.hidden = YES;
        self.launchWindow = nil;
    }
    mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    auto ctl = [[UIStoryboard storyboardWithName:@"GameChooser" bundle:nil] instantiateInitialViewController];
    mainWindow.rootViewController = ctl;
    [mainWindow makeKeyAndVisible];
    
    while (!getCataclysmFlavor()) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, true);
    }
    
    NSString* documentPath = getDocumentURL().path;
    [SentrySDK configureScope:^(SentryScope *_Nonnull scope) {
        for (NSString* file in @[@"/config/debug.log", @"/config/debug.log.prev", @"/config/options.json"])
            [scope addAttachment:[[SentryAttachment alloc] initWithPath:[documentPath stringByAppendingString:file]]];
    }];
    unFullScreen(documentPath);
    configureFirebase();
    if (!isUnlimitedFunctionalityUnlocked()) {
        auto eventsCountManager = [EventsCountManager new];
        auto closeActionDelegate = [ReturnToMainMenuPaywallCloseActionDelegate new];
        auto paywallDisplayEventSubscriberDelegate = [DefaultPaywallDisplayEventSubscriberDelegate newWith:eventsCountManager closeWhenTrialIsOverWith:closeActionDelegate];
        repeatTryingToSubscribeDisplayingPaywallToCDDAEventsUntilSucceeds(paywallDisplayEventSubscriberDelegate);
    }
    auto cDDARunArgs = getCDDARunArgs(documentPath);
    CDDA_main(std::get<0>(cDDARunArgs), std::get<1>(cDDARunArgs));
}

@end
