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
        [SentrySDK startWithOptions: @{
            @"dsn": [[NSBundle mainBundle] objectForInfoDictionaryKey: @"SentryDSN"],
#ifdef DEBUG
            @"debug": @YES,
            @"environment": @"development",
#else
            @"debug": @NO,
            @"environment": @"production",
#endif
        }];

        bool useICloudByDefault = (![[NSFileManager defaultManager] fileExistsAtPath:[getLocalDocumentPath() stringByAppendingString:@"config"]]) && getICloudDocumentPath();

        NSDictionary* appDefaults = @{
            @"overlayUIEnabled": @YES,
            @"invertScroll": @NO,
            @"invertPan": @NO,
            @"keyboardSwipeTime": @0.05,
            @"resizeGameWindowWhenTogglingKeyboard": @YES,
            @"panningWith1Finger": @NO,
            @"useICloud": [NSNumber numberWithBool:useICloudByDefault],
        };
        [NSUserDefaults.standardUserDefaults registerDefaults:appDefaults];

        [SentrySDK configureScope:^(SentryScope *_Nonnull scope) {
            for (NSString* file in @[@"config/debug.log", @"config/debug.log.prev", @"config/options.json"])
                [scope addAttachment:[[SentryAttachment alloc] initWithPath:[getDocumentPath() stringByAppendingString:file]]];
        }];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
