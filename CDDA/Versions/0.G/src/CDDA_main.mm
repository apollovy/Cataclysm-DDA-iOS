//
//  main.c
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//
#import <dlfcn.h>
#import <Foundation/Foundation.h>


typedef int (*CDDA_mainFunctionType)(int, char*[]);

int CDDA_main(int argc, char** argv) {
    int exitCode;
    void* cddaLib = dlopen("@rpath/CDDA0GFramework.framework/CDDA0GFramework", RTLD_NOW);
    if (cddaLib == NULL) {
        [NSException raise:@"cddaLib == NULL" format:@"%s", dlerror()];
    } else {
        void* initializer = dlsym(cddaLib, "main");
        if (initializer == NULL) {
            [NSException raise:@"cddaLib.initializer == NULL" format:@"%s", dlerror()];
        } else {
            CDDA_mainFunctionType main = (CDDA_mainFunctionType) initializer;
            exitCode = main(argc, argv);
        }
    }
    
    return exitCode;
}
