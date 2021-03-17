//
//  MainViewController.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "path_utils.h"
#import "CDDA_iOS_main.h"
#import "SSZipArchive.h"

#import "MainViewController.h"


@implementation MainViewController

- (IBAction)startApp:(id)sender
{
    self.view.window.hidden = YES;
    self.view = nil;
    CDDA_iOS_main(getDocumentURL().path);
}

- (IBAction)save:(id)sender
{
    NSURL* url = [getICloudDocumentURL() URLByAppendingPathComponent:@"/save.zip"];

    // zip
    NSString* documentsDir = getDocumentURL().path;
    [SSZipArchive createZipFileAtPath:url.path withContentsOfDirectory:documentsDir];
    
    // upload
    NSError* error = nil;
    NSString* status = nil;
    int attempt = 0;
    
    while (true)
    {
        if ([url getResourceValue:&status forKey:NSURLUbiquitousItemDownloadingStatusKey error:&error] == YES)
        {
            if ([status isEqualToString:NSURLUbiquitousItemDownloadingStatusCurrent] == YES)
            {
                if (attempt > 0)
                    NSLog(@"Downloaded %@ in %i attempts.", url, attempt);
                else
                    NSLog(@"%@ was already there.", url);
                return;
            } else {
                if (attempt == 0)
                {
                    [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:&error];
                }
                if (attempt >= 10)
                {
                    NSLog(@"%i attempts were made, giving up to download %@.", attempt, url);
                    return;
                }
                if (error)
                {
                    NSLog(@"Downloading %@ resulted in error: %@ after %i attempts.", url, error, attempt);
                    return;
                }
                attempt++;
                NSLog(@"Sleeping for 1 second for %@ in %i attempt.", url, attempt);
                [NSThread sleepForTimeInterval:1.0f];
            }
        } else {
            NSLog(@"Downloading %@ resulted in error: %@ after %i attempts.", url, error, attempt);
            return;
        }
    }
}

@end
