//
//  cArrayFromNSArray.cpp
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 16.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#include "cArrayFromNSArray.h"
#include <Foundation/Foundation.h>

// https://stackoverflow.com/a/15318065/674557
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
