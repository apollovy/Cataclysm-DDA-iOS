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

- (NSURL*)_getSaveUrl:(NSError**)errorPrt
{
    NSURL* iCloudDocumentURL = getICloudDocumentURL();
    NSString* iCloudDocumentsPath = iCloudDocumentURL.path;
    BOOL iCloudDocumentPathIsDir;
    
    if (!([NSFileManager.defaultManager fileExistsAtPath:iCloudDocumentsPath isDirectory:&iCloudDocumentPathIsDir] && iCloudDocumentPathIsDir))
        [NSFileManager.defaultManager createDirectoryAtPath:iCloudDocumentsPath withIntermediateDirectories:YES attributes:nil error:errorPrt];
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

-(void)load:(id)sender
{
    // download
    
    // unzip
}

@end
