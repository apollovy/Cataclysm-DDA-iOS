//
//  MainViewController.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "SSZipArchive.h"

#import "path_utils.h"
#import "CDDA_iOS_main.h"

#import "MainViewController.h"


@implementation MainViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.progressWrapper.alpha = 0;
}

-(void)startApp:(id)sender
{
    self.view = nil;
    CDDA_iOS_main(getDocumentURL().path);
}

-(void)save:(id)sender
{
    self.label.text = @"Saving...";
    [UIView animateWithDuration:0.2 animations:^{
        self.buttons.alpha = 0;
        self.progressWrapper.alpha = 1;
    }];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSURL* url = [getICloudDocumentURL() URLByAppendingPathComponent:@"save.zip"];

        // zip
        NSString* documentsDir = getDocumentURL().path;
        dispatch_queue_main_t  _Nonnull mainQ = dispatch_get_main_queue();
        [SSZipArchive createZipFileAtPath:url.path withContentsOfDirectory:documentsDir keepParentDirectory:NO compressionLevel:9 password:nil AES:NO progressHandler:^(NSUInteger entryNumber, NSUInteger total)
        {
            dispatch_async(mainQ, ^{
                self.progressView.progress = (float)entryNumber / total;
            });
        }];
        
        if (TARGET_OS_SIMULATOR)
        {
            dispatch_async(mainQ, ^{
                [UIView animateWithDuration:0.2 animations:^{
                    self.progressWrapper.alpha = 0;
                    self.buttons.alpha = 1;
                }];
            });

            return;
        }
        
        // upload
        dispatch_async(mainQ, ^{
            self.label.text = @"Uploading...";
            self.progressView.progress = 0;
            [UIView animateWithDuration:0.2 animations:^{
                self.progressWrapper.alpha = 1;
                self.buttons.alpha = 0;
            }];
        });

        NSError* error = nil;

        [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:&error];
        if (error)
        {
            dispatch_async(mainQ, ^{
                self.label.text = [NSString stringWithFormat:@"Upload failed: %@", error];
            });
            return;
        }
        _query = [NSMetadataQuery new];
        _query.predicate = [NSPredicate predicateWithFormat:@"%K = %@", NSMetadataItemURLKey, url];
        _query.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:nil];
        dispatch_async(mainQ, ^{
            bool queryStarted = [_query startQuery];
            if (!queryStarted)
            {
                dispatch_async(mainQ, ^{
                    self.label.text = [NSString stringWithFormat:@"Failed to start query %@", _query.predicate];
                });
                return;
            }
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
                while (_query.gathering)
                {
                    NSLog(@"Waiting for query to finish");
                    [NSThread sleepForTimeInterval:1];
                };
            });
        });
    });
}

NSMetadataQuery* _query;

-(void)queryDidFinishGathering:(NSNotification*)notification
{
    [_query stopQuery];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSMetadataItem* fileMetadata = [_query.results firstObject];
        NSNumber* percentUploaded = 0;
        dispatch_queue_main_t  _Nonnull mainQ = dispatch_get_main_queue();

        NSError* error = nil;
        [NSFileManager.defaultManager startDownloadingUbiquitousItemAtURL:[fileMetadata valueForKey:NSMetadataItemURLKey] error:&error];

        if (error)
            dispatch_async(mainQ, ^{
                self.label.text = [NSString stringWithFormat:@"Upload error: %@", error];
            });
        while ([percentUploaded intValue] != 100)
        {
            [NSThread sleepForTimeInterval:1];
            percentUploaded = [fileMetadata valueForKey:NSMetadataUbiquitousItemPercentUploadedKey];
            dispatch_async(mainQ, ^{
                self.progressView.progress = [percentUploaded floatValue] / 100;
            });
//            if ([fileMetadata valueForKey:NSMetadataUbiquitousItemDownloadingStatusKey] == NSMetadataUbiquitousItemDownloadingStatusCurrent)
//            {
//                dispatch_async(mainQ, ^{
//                    self.progressView.progress = 100;
//                });
//                break;
//            }
        }
        dispatch_async(mainQ, ^{
            [UIView animateWithDuration:0.2 animations:^{
                self.progressWrapper.alpha = 0;
                self.buttons.alpha = 1;
            }];
        });

    });
}

-(void)load:(id)sender
{
    // download
    
    // unzip
}

@end
