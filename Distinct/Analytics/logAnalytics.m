//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>

#import "cdda_firebase.h"

#import "logAnalytics.h"


void logAnalytics(NSString* name, NSDictionary* params) {
    NSMutableDictionary* newParams = [params mutableCopy];
    NSString* testGroup = getTestGroup();
    [newParams addEntriesFromDictionary:@{
            @"testGroup": testGroup,
    }];
    [FIRAnalytics logEventWithName:name parameters:newParams];
}
