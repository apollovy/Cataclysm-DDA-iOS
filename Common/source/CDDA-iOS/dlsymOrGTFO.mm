//
//  dlsymOrGTFO.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 18.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <dlfcn.h>
#import <Foundation/Foundation.h>


void* dlsymOrGTFO(void* handle, const char* symbol)
{
    void* sym_ptr = dlsym(handle, symbol);
    if (sym_ptr == NULL)
    {
        [NSException raise:@"Symbol not found" format:@"%s", dlerror()];
    }
    return sym_ptr;
}
