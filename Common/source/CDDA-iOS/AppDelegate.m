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


static void unFullScreen(NSString *documentPath) {
    NSError* error = nil;
    NSString* optionsPath = [documentPath stringByAppendingString:@"/config/options.json"];
    NSInputStream* readStream = [NSInputStream inputStreamWithFileAtPath:optionsPath];
    [readStream open];
    NSArray<NSDictionary<NSString*, NSString*>*>* settings = [NSJSONSerialization JSONObjectWithStream:readStream options:NSJSONReadingMutableContainers
                                        error:&error];
    [readStream close];
    
    if (!settings) {return;}
    
    for (NSDictionary<NSString*, NSString*>* setting in settings)
    {
        if ([[setting valueForKey:@"name"] isEqual: @"FULLSCREEN"])
        {
            [setting setValue:@"no" forKey:@"value"];
            break;
        }
    }
    
    NSOutputStream* writeStream = [NSOutputStream outputStreamToFileAtPath:optionsPath append:NO];
    [writeStream open];
    [NSJSONSerialization writeJSONObject:settings toStream:writeStream options:0 error:&error];
    [writeStream close];
}


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
    // TODO: return this when Main.storyboard will work OK when it's initial for the app on GPU-enhanced devices
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [sb instantiateInitialViewController];
//    vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    mainWindow.rootViewController = vc;
//    [mainWindow makeKeyAndVisible];
    NSString* documentPath = getDocumentURL().path;
    unFullScreen(documentPath);
    CDDA_iOS_main(documentPath);
}

@end
