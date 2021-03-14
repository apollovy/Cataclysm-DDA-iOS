//
//  ViewController.m
//  SDLPlayground2
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "path_utils.h"
#import "CDDA_iOS_main.h"

#import "ViewController.h"


@implementation ViewController

#pragma mark - download from iCloud

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([NSUserDefaults.standardUserDefaults boolForKey:@"useICloud"])
    {
        NSString* documentPath = getICloudDocumentURL().path;

        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K like %@", NSMetadataItemPathKey, [documentPath stringByAppendingString:@"/*"]];
        _query = [NSMetadataQuery new];
        _query.searchScopes = @[NSMetadataQueryUbiquitousDocumentsScope];
        _query.predicate = predicate;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) name:NSMetadataQueryDidFinishGatheringNotification object:nil];
        [_query startQuery];
    }
}

NSMetadataQuery* _query;
// FIXME: nothing gets downloaded (or at least is reported that way), but I see files being downloaded.
// Also strange names of files appear in logs, but nowhere else, even in source local copy.
// Also no saves are suddenly visible from the game. No idea what's the issue.
// Maybe create a giant table, where every cell is a file being downloaded and report status for each cell? Should be very visual :)
// Also meybe it's worth it to check not for NSURLUbiquitousItemDownloadingStatusCurrent, but for NSURLUbiquitousItemDownloadingStatusDownloaded?

// OK, looks like I've figured out all that stuff with build number and friends. But now the app is not loading sometimes. Just black screen and nothing more. Even no traces of downloading stuff. Weirdo.
// Oh, it's hanging on `getICloudDocumentURL()` !! Possibly some kind of deadlock or something.
-(void)queryDidFinishGathering:(NSNotification*)notification
{
    dispatch_queue_global_t bgQ = dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0);
    for (NSMetadataItem* item in _query.results)
    {
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        dispatch_async(bgQ, ^(void){
            NSError* error = nil;
            NSString* downloadingStatus = nil;
            int downloadAttempt = 0;

            while (true)
            {
                if ([url getResourceValue:&downloadingStatus forKey:NSURLUbiquitousItemDownloadingStatusKey error:&error] == YES)
                {
                    if ([downloadingStatus isEqualToString:NSURLUbiquitousItemDownloadingStatusCurrent] == YES)
                    {
                        if (downloadAttempt > 0)
                            NSLog(@"Downloaded %@ in %i attempts.", url, downloadAttempt);
                        else
                            NSLog(@"%@ was already there.", url);
                        return;
                    } else {
                        if (downloadAttempt >= 10)
                        {
                            NSLog(@"%i attempts were made, giving up to download %@.", downloadAttempt, url);
                            return;
                        }
                        [[NSFileManager defaultManager] startDownloadingUbiquitousItemAtURL:url error:&error];
                        if (error)
                        {
                            NSLog(@"Downloading %@ resulted in error: %@ after %i attempts.", url, error, downloadAttempt);
                            return;
                        }
                        downloadAttempt++;
                        NSLog(@"Sleeping for 1 second for %@ in %i attempt.", url, downloadAttempt);
                        [NSThread sleepForTimeInterval:1.0f];
                    }
                } else {
                    NSLog(@"Downloading %@ resulted in error: %@ after %i attempts.", url, error, downloadAttempt);
                    return;
                }
            }
        });
    }
}

- (IBAction)startApp:(id)sender
{
    self.view.window.hidden = YES;
    self.view = nil;
    CDDA_iOS_main(getDocumentURL().path);
}

@end
