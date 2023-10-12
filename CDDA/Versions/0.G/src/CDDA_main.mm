//
//  main.c
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//
#import <dlfcn.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IndependentChosenDelegate.h"


typedef int (*CDDA_mainFunctionType)(int, char*[]);


// FIXME!!!!!
int _argc;
char** _argv;


int CDDA_main(int argc, char** argv) {
    _argc = argc;
    _argv = argv;
    UIViewController* vc = [[UIStoryboard storyboardWithName:@"GameChooser" bundle:nil] instantiateInitialViewController];
    auto window = [[UIApplication.sharedApplication windows] firstObject];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
    return 0;
}

@implementation IndependentChosenDelegate

- (void)firstChosen:(id)sender {
    auto window = [[UIApplication.sharedApplication windows] firstObject];
    window.rootViewController = nil;
    window.hidden = @YES;
    
    void* cddaLib = dlopen("@rpath/CDDA0GFramework.framework/CDDA0GFramework", RTLD_NOW);
    if (cddaLib == NULL) {
        [NSException raise:@"cddaLib == NULL" format:@"%s", dlerror()];
    } else {
        void* initializer = dlsym(cddaLib, "main");
        if (initializer == NULL) {
            [NSException raise:@"cddaLib.initializer == NULL" format:@"%s", dlerror()];
        } else {
            CDDA_mainFunctionType main = (CDDA_mainFunctionType) initializer;
            main(_argc, _argv);
        }
    }
}

- (void)secondChosen:(id)sender {
    NSLog(@"Not implemented");
}

@end
