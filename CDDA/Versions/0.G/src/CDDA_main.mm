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

NSString* getCataclysmFlavor(void)
{
    auto runDDA = [NSUserDefaults.standardUserDefaults boolForKey:@"runDDA"];
    return runDDA ? @"CDDA0G" : @"CBN";
}

int CDDA_main(int argc, char** argv)
{
    NSString* flavor = getCataclysmFlavor();
    auto libPath = [[NSString stringWithFormat:@"@rpath/%@Framework.framework/%@Framework", flavor, flavor] cStringUsingEncoding:kCFStringEncodingUTF8];
    void* cddaLib = dlopen(libPath, RTLD_NOW);
    if (cddaLib == NULL) {
        [NSException raise:@"cddaLib == NULL" format:@"%s", dlerror()];
        return -1;
    } else {
        void* initializer = dlsym(cddaLib, "main");
        if (initializer == NULL) {
            [NSException raise:@"cddaLib.initializer == NULL" format:@"%s", dlerror()];
            return -2;
        } else {
            CDDA_mainFunctionType main = (CDDA_mainFunctionType) initializer;
            return main(argc, argv);
        }
    }
}
