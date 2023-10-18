//
//  main.c
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//
#import <dlfcn.h>
#import <Foundation/Foundation.h>
#import "getCataclysmFlavor.h"
#import "CDDAAPI.h"
#import "ReturnToMainMenuPaywallCloseActionDelegate.h"
#import "dlsymOrGTFO.h"

typedef int (*CDDA_mainFunctionType)(int, char*[]);

int CDDA_main(int argc, char** argv)
{
    NSString* flavor = getCataclysmFlavor();
    auto libPath = [[NSString stringWithFormat:@"@rpath/%@Framework.framework/%@Framework", flavor, flavor] cStringUsingEncoding:NSUTF8StringEncoding];
    void* cddaLib = dlopen(libPath, RTLD_LAZY);
    if (cddaLib == NULL) {
        [NSException raise:@"cddaLib == NULL" format:@"%s", dlerror()];
        return -1;
    } else {
        void* main_ptr = dlsymOrGTFO(cddaLib, "CATA_main");
        void* returnToMainMenu_ptr = dlsymOrGTFO(cddaLib, "CDDAAPI_returnToMainMenu");
        CDDAAPI::returnToMainMenu_ptr = (CDDAAPI::void_f*)returnToMainMenu_ptr;
        void* subscribeDisplayingPaywallToCDDAEvents_ptr = dlsymOrGTFO(cddaLib, "CDDAAPI_subscribeDisplayingPaywallToCDDAEvents");
        CDDAAPI::subscribeDisplayingPaywallToCDDAEvents_ptr = (CDDAAPI::subscribeDisplayingPaywallToCDDAEvents_f*)subscribeDisplayingPaywallToCDDAEvents_ptr;
        CDDA_mainFunctionType CATA_main = (CDDA_mainFunctionType) main_ptr;
        return CATA_main(argc, argv);
    }
}
