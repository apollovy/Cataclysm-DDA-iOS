//
//  main.c
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//
#import <dlfcn.h>
#import <stdio.h>


typedef int (*CDDA_mainFunctionType)(int, char*[]);

int CDDA_main(int argc, char** argv) {
    int exitCode;
    void* cddaLib = dlopen("Frameworks/CDDA0GFramework.framework/CDDA0GFramework", RTLD_NOW);
    if (cddaLib == NULL) {
        printf("cddaLib == NULL: %s", dlerror());
        exitCode = -1;
    } else {
        void* initializer = dlsym(cddaLib, "main");
        if (initializer == NULL) {
            printf("initializer == NULL: %s",  dlerror());
            exitCode = -2;
        } else {
            CDDA_mainFunctionType main = (CDDA_mainFunctionType) initializer;
            exitCode = main(argc, argv);
        }
    }
    
    return exitCode;
}
