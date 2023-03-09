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

#import "MainViewController.h"


@implementation MainViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.playButton setHidden:self.hidePlayButton];
    self.progressWrapper.alpha = 0;
}

-(void)openSettings:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
#pragma clang diagnostic pop
}

-(void)save:(id)sender
{
    [self _showProgressScreenWithLabel:NSLocalizedString(@"Saving...", @"")];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSError* error = nil;
        NSURL* url = [self _getSaveUrl:&error];
        
        if (error)
        {
            [self _showMainScreenWithMessage:NSLocalizedString(@"Error getting URL for save", @"") error:error];
            return;
        }

        [ZipArchiver zip:getDocumentURL() destination:url errorPtr:&error progress:^(double progress)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progressView.progress = (float)progress;
            });
        }];
        
        if (error)
        {
            [self _showMainScreenWithMessage:NSLocalizedString(@"Error zipping save", @"") error:error];
            return;
        }
        
        if (TARGET_OS_SIMULATOR)
        {
            [self _showMainScreenWithMessage:NSLocalizedString(@"Save successful", @"") error:error];
            return;
        }

#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnreachableCode"
        [self _showProgressScreenWithLabel:NSLocalizedString(@"Uploading...", @"")];
        [self _watchProgressForURL:url finishingWith:@selector(_checkUploadFinished:)];
#pragma clang diagnostic pop
    });
}

-(void)load:(id)sender
{
    [self _showProgressScreenWithLabel:NSLocalizedString(@"Downloading...", @"")];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0) , ^{
        NSError* error = nil;
        NSURL* url = [self _getSaveUrl:&error];
        
        if (error)
        {
            [self _showMainScreenWithMessage:NSLocalizedString(@"Error getting URL for save", @:"") error:error];
            return;
        }
        
        if (TARGET_OS_SIMULATOR)
        {
            [self _unzip:url];
#pragma clang diagnostic push
#pragma ide diagnostic ignored "UnreachableCode"
        } else {
            [self _watchProgressForURL:url finishingWith:@selector(_checkDownloadFinishedAndUnzip:)];
#pragma clang diagnostic pop
        }
    });
}

-(void)play:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)_watchProgressForURL:(NSURL*)url finishingWith:(SEL)selector
{
    NSError* error;
    [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:&error];

    if (error)
    {
        [self _showMainScreenWithMessage:NSLocalizedString(@"Download start failed", @"") error:error];
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
            [self _showMainScreenWithMessage:NSLocalizedString(@"Failed to start query", "") error:nil];
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
    [self _showProgressScreenWithLabel:NSLocalizedString(@"Unpacking...", @"")];
    NSURL* documentURL = getDocumentURL();
    NSString* documentPath = documentURL.path;
    NSError* error = nil;

    [[NSFileManager.defaultManager contentsOfDirectoryAtPath:documentPath error:&error] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError* error1 = nil;
        
        if (![ZipArchiver.savedDirs containsObject:obj])
            return;

        [NSFileManager.defaultManager removeItemAtPath:[documentPath stringByAppendingPathComponent:obj] error:&error1];
    
        if (error1)
        {
            [self _showMainScreenWithMessage:NSLocalizedString(@"Removing file failed", "") error:error1];
            return;
        }
    }];

    if (error)
    {
        [self _showMainScreenWithMessage:NSLocalizedString(@"Listing contents of directory failed", @"") error:error];
        return;
    }

    [ZipArchiver unzip:url destination:documentURL errorPtr:&error progress:^(double progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.progressView.progress = (float)progress;
        });
    }];

    if (error)
    {
        [self _showMainScreenWithMessage:NSLocalizedString(@"Error unzipping save", "") error:error];
        return;
    }

    [self _showMainScreenWithMessage:NSLocalizedString(@"Load successful", @"") error:nil];
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
        [self _showMainScreenWithMessage:NSLocalizedString(@"Upload successful!", @"") error:nil];
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
