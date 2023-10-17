//
//  main.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Sentry.h"

#import "AppDelegate.h"
#import "path_utils.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [SentrySDK startWithConfigureOptions:^(SentryOptions *options) {
            options.dsn = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"SentryDSN"];
            options.debug = NO;
#ifdef DEBUG
            options.environment = @"development";
#else
            options.environment = @"production";
#endif
        }];

        NSDictionary* appDefaults = @{
            @"overlayUIEnabled": @YES,
            @"invertScroll": @NO,
            @"invertPan": @NO,
            @"keyboardSwipeTime": @0.05,
            @"resizeGameWindowWhenTogglingKeyboard": @YES,
            @"panningWith1Finger": @NO,
            @"screenAutoresize": @NO,
        };
        [NSUserDefaults.standardUserDefaults registerDefaults:appDefaults];

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
