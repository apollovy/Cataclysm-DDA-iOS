//
//  path_utils.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "path_utils.h"
#import "getCataclysmFlavor.h"

NSURL* getICloudDocumentURL(void)
{
    NSString* flavor = getCataclysmFlavor();
    NSURL* url;
    if (TARGET_OS_SIMULATOR)
    {
        NSString* path = [NSString stringWithFormat:@"/tmp/CDDA-iOS/iCloud/%@", flavor];
        NSError* error;
        bool created = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created){
            NSLog(@"Directory creation failed: %@", error);
            @throw error;
        }
        else
            url = [NSURL fileURLWithPath:path isDirectory: YES];
    }
    else
        url = [[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:flavor];
    
    return url;
}

NSURL* getDocumentURL(void)
{
    return [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:getCataclysmFlavor()];
}
