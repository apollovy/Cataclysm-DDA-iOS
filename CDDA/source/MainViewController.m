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
    [self _showProgressScreenWithLabel:@"Saving..."];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSError* error = nil;
        NSURL* url = [self _getSaveUrl:&error];
        
        if (error)
        {
            [self _showMainScreenWithMessage:@"Error getting URL for save" error:error];
            return;
        }

        [ZipArchiver zip:getDocumentURL() destination:url errorPtr:&error progress:^(double progress)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = progress;
            });
        }];
        
        if (error)
        {
            [self _showMainScreenWithMessage:@"Error zipping save" error:error];
            return;
        }
        
        if (TARGET_OS_SIMULATOR)
        {
            [self _showMainScreenWithMessage:@"Save successful" error:error];
            return;
        }
        
        [self _showProgressScreenWithLabel:@"Uploading..."];
        [self _watchProgressForURL:url finishingWith:@selector(_checkUploadFinished:)];
    });
}

-(void)load:(id)sender
{
    [self _showProgressScreenWithLabel:@"Downloading..."];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSError* error = nil;
        NSURL* url = [self _getSaveUrl:&error];
        
        if (error)
        {
            [self _showMainScreenWithMessage:@"Error getting URL for save" error:error];
            return;
        }
        
        if (TARGET_OS_SIMULATOR)
        {
            [self _unzip:url];
        } else {
            [self _watchProgressForURL:url finishingWith:@selector(_checkDownloadFinishedAndUnzip:)];
        }
    });
}

-(void)_watchProgressForURL:(NSURL*)url finishingWith:(SEL)selector
{
    NSError* error;
    [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:&error];

    if (error)
    {
        [self _showMainScreenWithMessage:@"Download start failed" error:error];
        return;
    }

    _query = [NSMetadataQuery new];
    _query.predicate = [NSPredicate predicateWithFormat:@"%K = %@", NSMetadataItemURLKey, url];
    _query.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];

    for (NSNotificationName notificationName in @[NSMetadataQueryDidFinishGatheringNotification, NSMetadataQueryDidUpdateNotification])
        [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notificationName object:nil];

    dispatch_async(dispatch_get_main_queue(), ^{
        bool queryStarted = [_query startQuery];
        if (!queryStarted)
        {
            [self _showMainScreenWithMessage:@"Failed to start query" error:nil];
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

- (void)_unzip:(NSURL*)url
{
    [self _showProgressScreenWithLabel:@"Unpacking..."];
    NSURL* documentURL = getDocumentURL();
    NSString* documentPath = documentURL.path;
    NSError* error = nil;

    [[NSFileManager.defaultManager contentsOfDirectoryAtPath:documentPath error:&error] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError* error = nil;
        [NSFileManager.defaultManager removeItemAtPath:[documentPath stringByAppendingPathComponent:obj] error:&error];
    
        if (error)
        {
            [self _showMainScreenWithMessage:@"Removing file failed" error:error];
            return;
        }
    }];

    if (error)
    {
        [self _showMainScreenWithMessage:@"Listing contents of directory failed" error:error];
        return;
    }

    [ZipArchiver unzip:url destination:documentURL errorPtr:&error progress:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = progress;
        });
    }];

    if (error)
    {
        [self _showMainScreenWithMessage:@"Error unzipping save" error:error];
        return;
    }

    NSString* innerDocumentsPath = [documentURL URLByAppendingPathComponent:@"/Documents"].path;
    [[NSFileManager.defaultManager contentsOfDirectoryAtPath:innerDocumentsPath error:&error] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError* error = nil;
        [NSFileManager.defaultManager moveItemAtPath:[innerDocumentsPath stringByAppendingPathComponent:obj] toPath:[documentPath stringByAppendingPathComponent:obj] error:&error];

        if (error)
        {
            [self _showMainScreenWithMessage:@"Moving directory failed" error:error];
            return;
        }
    }];

    if (error)
    {
        [self _showMainScreenWithMessage:@"Listing contents of directory failed" error:error];
        return;
    }

    [NSFileManager.defaultManager removeItemAtPath:innerDocumentsPath error:&error];
    if (error)
        NSLog(@"Removing inner documents directory %@ failed with %@", innerDocumentsPath, error);

    [self _showMainScreenWithMessage:@"Load successful" error:nil];
}

-(void)_checkDownloadFinishedAndUnzip:(NSNotification*)notification
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

-(void)_checkUploadFinished:(NSNotification*)notification
{
    NSMetadataItem* fileMetadata = [_query.results firstObject];
    NSNumber* percentUploaded = [fileMetadata valueForKey:NSMetadataUbiquitousItemPercentUploadedKey];
    self.progressView.progress = [percentUploaded floatValue] / 100;

    if ([percentUploaded intValue] == 100)
    {
        [_query disableUpdates];
        [_query stopQuery];
        for (NSNotificationName notificationName in @[NSMetadataQueryDidFinishGatheringNotification, NSMetadataQueryDidUpdateNotification])
            [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
        [self _showMainScreenWithMessage:@"Upload successful!" error:nil];
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

- (void)_showProgressScreenWithLabel:(NSString*)label
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label.text = label;
        self.progressView.progress = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.buttons.alpha = 0;
            self.progressWrapper.alpha = 1;
        }];
    });
}

-(void)_showMainScreenWithMessage:(NSString*)message error:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.progressWrapper.alpha = 0;
            self.buttons.alpha = 1;
        }];
        
        NSString* title = error ? error.localizedDescription : message;
        NSString* alertMessage = error ? error.localizedFailureReason : message;

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
