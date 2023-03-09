//
//  unFullScreen.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 07.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

# import <Foundation/Foundation.h>
# import "unFullScreen.h"

void unFullScreen(NSString *documentPath) {
    NSError* error = nil;
    NSString* optionsPath = [documentPath stringByAppendingString:@"/config/options.json"];
    NSInputStream* readStream = [NSInputStream inputStreamWithFileAtPath:optionsPath];
    [readStream open];
    NSArray<NSDictionary<NSString*, NSString*>*>* settings = [
        NSJSONSerialization
        JSONObjectWithStream:readStream
        options:NSJSONReadingMutableContainers
        error:&error
    ];
    [readStream close];
    
    if (!settings) {return;}
    
    for (NSDictionary<NSString*, NSString*>* setting in settings)
    {
        if ([[setting valueForKey:@"name"] isEqual: @"FULLSCREEN"])
        {
            [setting setValue:@"no" forKey:@"value"];
            break;
        }
    }
    
    NSOutputStream* writeStream = [NSOutputStream
                                   outputStreamToFileAtPath:optionsPath
                                   append:NO];
    [writeStream open];
    [NSJSONSerialization
     writeJSONObject:settings
     toStream:writeStream
     options:0
     error:&error];
    [writeStream close];
}
