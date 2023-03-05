//
//  path_utils.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "path_utils.h"

NSURL* getICloudDocumentURL()
{
    NSURL* url;
    if (TARGET_OS_SIMULATOR)
    {
        NSError* error;
        bool created = [[NSFileManager defaultManager] createDirectoryAtPath:@"/tmp/CDDA-iOS/iCloud" withIntermediateDirectories:YES attributes:nil error:&error];
        if (!created){
            NSLog(@"Directory creation failed: %@", error);
            @throw error;
        }
        else
            url = [NSURL fileURLWithPath:@"/tmp/CDDA-iOS/iCloud" isDirectory: YES];
    }
    else
        url = [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"];
    
    return url;
}

NSURL* getDocumentURL()
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
