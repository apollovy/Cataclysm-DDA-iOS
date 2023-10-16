//
//  getCDDARunArgs.c
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 16.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#include <tuple>
#include <Foundation/Foundation.h>
#include "getCDDARunArgs.h"
#include "cArrayFromNSArray.h"
#include "getCataclysmFlavor.h"

std::tuple<int, char**>getCDDARunArgs(NSString* documentPath)
{
    NSArray<NSString*>* arguments = NSProcessInfo.processInfo.arguments;
    NSString* pathInFramework = [NSString stringWithFormat:@"/%@Framework.framework/", getCataclysmFlavor()];
    NSString* frameworkRootDir = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingString:pathInFramework];
    [NSFileManager.defaultManager changeCurrentDirectoryPath:frameworkRootDir];
    NSArray<NSString*>* newArguments = [arguments arrayByAddingObjectsFromArray:@[
        @"--datadir", [frameworkRootDir stringByAppendingString:@"data/"],
         @"--userdir", [documentPath stringByAppendingString:@"/"],
         
    ]];
    int newArgumentsCount = static_cast<int>(newArguments.count);
    char** stringArgs = cArrayFromNSArray(newArguments);
    
    return {newArgumentsCount, stringArgs};
}
