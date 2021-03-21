//
//  MainViewController.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "CDDA-Swift.h"

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
    self.progressView.progress = 0;
    [self _showProgressScreen];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSError* error = nil;
        NSURL* url = [self _getSaveUrl:&error];
        dispatch_queue_main_t  _Nonnull mainQ = dispatch_get_main_queue();
        
        if (error)
        {
            NSLog(@"Error getting URL for save: %@", error);
            [self _showMainScreen];
            return;
        }

        // zip
        [ZipArchiver zip:getDocumentURL() destination:url errorPtr:&error progress:^(double progress)
        {
            dispatch_async(mainQ, ^{
                self.progressView.progress = progress;
            });
        }];
        
        if (error)
        {
            NSLog(@"Error zipping save: %@", error);
            [self _showMainScreen];
            return;
        }
        
        if (TARGET_OS_SIMULATOR)
        {
            [self _showMainScreen];
            return;
        }
        
        // upload
        [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:&error];
        if (error)
        {
            NSLog(@"Upload failed: %@", error);
        }
        [self _showMainScreen];
    });
}

-(void)load:(id)sender
{
    self.label.text = @"Downloading...";
    [self _showProgressScreen];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSError* error = nil;
        NSURL* url = [self _getSaveUrl:&error];
        dispatch_queue_main_t _Nonnull mainQ = dispatch_get_main_queue();
        
        if (error)
        {
            NSLog(@"Error getting URL for save: %@", error);
            [self _showMainScreen];
            return;
        }
        
        // download
        if (TARGET_OS_SIMULATOR)
        {
            [self _unzip:url];
        } else {
            [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:&error];
            if (error)
            {
                NSLog(@"Download start failed: %@", error);
                [self _showMainScreen];
                return;
            }
            _query = [NSMetadataQuery new];
            _query.predicate = [NSPredicate predicateWithFormat:@"%K = %@", NSMetadataItemURLKey, url];
            _query.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
            for (NSNotificationName notificationName in @[NSMetadataQueryDidFinishGatheringNotification, NSMetadataQueryDidUpdateNotification])
                [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(_queryDidFinishGathering:) name:notificationName object:nil];
            dispatch_async(mainQ, ^{
                bool queryStarted = [_query startQuery];
                if (!queryStarted)
                {
                    NSLog(@"Failed to start query %@", _query.predicate);
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
        }
    });
}

- (void)_unzip:(NSURL*)url
{
    dispatch_queue_main_t _Nonnull mainQ = dispatch_get_main_queue();
    dispatch_async(mainQ, ^{
        self.label.text = @"Unpacking...";
        self.progressView.progress = 0;
    });
    NSURL* documentURL = getDocumentURL();
    NSString* documentPath = documentURL.path;
    NSError* error = nil;
    [[NSFileManager.defaultManager contentsOfDirectoryAtPath:documentPath error:&error] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError* error = nil;
        [NSFileManager.defaultManager removeItemAtPath:[documentPath stringByAppendingPathComponent:obj] error:&error];
        if (error)
            NSLog(@"Removing %@ failed with %@", obj, error);
    }];
    if (error)
        NSLog(@"Listing contents of directory %@ failed with %@. Proceeding...", documentPath, error);

    [ZipArchiver unzip:url destination:documentURL errorPtr:&error progress:^(double progress) {
        dispatch_async(mainQ, ^{
            self.progressView.progress = progress;
        });
    }];
    if (error)
    {
        NSLog(@"Error unzipping save: %@", error);
        [self _showMainScreen];
        return;
    }

    NSString* innerDocumentsPath = [documentURL URLByAppendingPathComponent:@"/Documents"].path;
    [[NSFileManager.defaultManager contentsOfDirectoryAtPath:innerDocumentsPath error:&error] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError* error = nil;
        [NSFileManager.defaultManager moveItemAtPath:[innerDocumentsPath stringByAppendingPathComponent:obj] toPath:[documentPath stringByAppendingPathComponent:obj] error:&error];
        if (error)
            NSLog(@"Moving %@ failed with %@", obj, error);
    }];
    if (error)
        NSLog(@"Listing contents of directory %@ failed with %@", innerDocumentsPath, error);

    [NSFileManager.defaultManager removeItemAtPath:innerDocumentsPath error:&error];
    if (error)
        NSLog(@"Removing inner documents directory %@ failed with %@", innerDocumentsPath, error);

    [self _showMainScreen];
}

-(void)_queryDidFinishGathering:(NSNotification*)notification
{
    NSMetadataItem* fileMetadata = [_query.results firstObject];
    NSNumber* percentDownloaded = [fileMetadata valueForKey:NSMetadataUbiquitousItemPercentDownloadedKey];
    self.progressView.progress = [percentDownloaded floatValue] / 100;
    BOOL saveArchiveIsCurrent = [fileMetadata valueForKey:NSMetadataUbiquitousItemDownloadingStatusKey] == NSMetadataUbiquitousItemDownloadingStatusCurrent;

    if (([percentDownloaded intValue] == 100) || saveArchiveIsCurrent)
    {
        [_query disableUpdates];
        [_query stopQuery];
        for (NSNotificationName notificationName in @[NSMetadataQueryDidFinishGatheringNotification, NSMetadataQueryDidUpdateNotification])
            [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];

        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
            [self _unzip:[fileMetadata valueForKey:NSMetadataItemURLKey]];
        });
    }
}

NSMetadataQuery* _query;

- (NSURL*)_getSaveUrl:(NSError**)errorPtr
{
    NSURL* iCloudDocumentURL = getICloudDocumentURL();
    NSString* iCloudDocumentsPath = iCloudDocumentURL.path;
    BOOL iCloudDocumentPathIsDir;
    
    if (!([NSFileManager.defaultManager fileExistsAtPath:iCloudDocumentsPath isDirectory:&iCloudDocumentPathIsDir] && iCloudDocumentPathIsDir))
        [NSFileManager.defaultManager createDirectoryAtPath:iCloudDocumentsPath withIntermediateDirectories:YES attributes:nil error:errorPtr];
    NSURL* url = [iCloudDocumentURL URLByAppendingPathComponent:@"save.zip"];
    return url;
}

- (void)_showProgressScreen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.buttons.alpha = 0;
            self.progressWrapper.alpha = 1;
        }];
    });
}

- (void)_showMainScreen
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.progressWrapper.alpha = 0;
            self.buttons.alpha = 1;
        }];
    });
}

@end
