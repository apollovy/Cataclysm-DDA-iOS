//
//  ViewController.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#include <dlfcn.h>
#import "ViewController.h"

extern "C" {
#import "path_utils.h"
}

@interface ViewController ()

@end

char** cArrayFromNSArray(NSArray* array)
{
    int i, count = static_cast<int>(array.count);
    char** cargs = (char**) malloc(sizeof(char*) * (count + 1));
    for(i = 0; i < count; i++) {
        NSString *s = array[static_cast<NSUInteger>(i)];
        const char *cstr = s.UTF8String;
        int len = static_cast<int>(strlen(cstr));
        char* cstr_copy = (char*) malloc(sizeof(char) * (len + 1));
        strcpy(cstr_copy, cstr);
        cargs[i] = cstr_copy;
    }
    cargs[i] = NULL;
    return cargs;
}

typedef int (*CDDA_mainFunctionType)(int, char*[]);

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* documentPath = getDocumentURL().path;
    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    NSString* datadir = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/data/"];
    NSArray<NSString*>* newArguments = [arguments arrayByAddingObjectsFromArray:@[
        @"--datadir", datadir,
        @"--userdir", [documentPath stringByAppendingString:@"/"],
        
    ]];
    int newArgumentsCount = static_cast<int>(newArguments.count);
    char** stringArgs = cArrayFromNSArray(newArguments);
    
    void* cddaLib = dlopen("Frameworks/CDDA0GFramework.framework/CDDA0GFramework", RTLD_NOW);
    if (cddaLib == NULL) {
        NSLog(@"cddaLib == NULL: %s", dlerror());
        return;
    } else {
        void* initializer = dlsym(cddaLib, "CDDA_main");
        if (initializer == NULL) {
            NSLog(@"initializer == NULL: %s",  dlerror());
            return;
        } else {
            CDDA_mainFunctionType CDDA_main = (CDDA_mainFunctionType) initializer;
            CDDA_main(newArgumentsCount, stringArgs);
        }
    }
}


@end
