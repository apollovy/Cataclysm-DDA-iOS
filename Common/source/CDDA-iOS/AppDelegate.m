//
//  AppDelegate.m
//  SDLPlayground2
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "AppDelegate.h"

#import "path_utils.h"
#import "CDDA_iOS_main.h"
#import "unFullScreen.h"


@implementation AppDelegate
{
    UIWindow* mainWindow;
}
+ (NSString *)getAppDelegateClassName
{
    /* subclassing notice: when you subclass this appdelegate, make sure to add
     * a category to override this method and return the actual name of the
     * delegate */
    return @"AppDelegate";
}
- (void)postFinishLaunch
{
    /* Hide the launch screen the next time the run loop is run. SDL apps will
     * have a chance to load resources while the launch screen is still up. */
    [self performSelector:@selector(hideLaunchScreen) withObject:nil afterDelay:0.0];

    if (self.launchWindow) {
        self.launchWindow.hidden = YES;
        self.launchWindow = nil;
    }
    mainWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString* documentPath = getDocumentURL().path;
    unFullScreen(documentPath);
    CDDA_iOS_main(documentPath);
}

@end
