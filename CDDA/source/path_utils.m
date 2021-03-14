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
    return [[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"];
}

NSURL* getLocalDocumentURL()
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

NSURL* getDocumentURL()
{
    NSURL* documentPath;
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"useICloud"])
        documentPath = getICloudDocumentURL();
    else
        documentPath = getLocalDocumentURL();
    
    return documentPath;
}
