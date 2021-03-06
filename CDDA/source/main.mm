#include <Foundation/Foundation.h>
#import "Sentry.h"

#define main CDDA_main
#include "main.cpp"
#undef main
#include "SDL_main.h"

int main( int argc, char *argv[] )
{
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

    NSString* iCloudDocumentPath = [[[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"] path]stringByAppendingString:@"/"];
    NSString* localDocumentPath = [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingString:@"/"];

    bool useICloudByDefault = (![[NSFileManager defaultManager] fileExistsAtPath:[localDocumentPath stringByAppendingString:@"config"]]) && iCloudDocumentPath;

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

    NSString* documentPath;
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"useICloud"])
        documentPath = iCloudDocumentPath;
    else
        documentPath = localDocumentPath;

    [SentrySDK configureScope:^(SentryScope *_Nonnull scope) {
        for (NSString* file in @[@"config/debug.log", @"config/debug.log.prev", @"config/options.json"])
            [scope addAttachment:[[SentryAttachment alloc] initWithPath:[documentPath stringByAppendingString:file]]];
    }];

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
