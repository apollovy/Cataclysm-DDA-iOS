//
//  path_utils.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "path_utils.h"

NSString* getICloudDocumentPath()
{
    return [[[[[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil] URLByAppendingPathComponent:@"Documents"] path]stringByAppendingString:@"/"];
}

NSString* getLocalDocumentPath()
{
    return [[[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] path] stringByAppendingString:@"/"];
}

NSString* getDocumentPath()
{
    NSString* documentPath;
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"useICloud"])
        documentPath = getICloudDocumentPath();
    else
        documentPath = getLocalDocumentPath();
    
    return documentPath;
}
