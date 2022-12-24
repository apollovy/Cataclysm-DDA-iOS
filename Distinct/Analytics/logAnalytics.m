//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>

#import "cdda_firebase.h"

#import "logAnalytics.h"
#import "PaywallUnlimitedFunctionality.h"


NSString* makeCDDAKeyName(NSString* key) {
    return [NSString stringWithFormat:@"cdda_%@", key];
}

void logAnalytics(NSString* name, NSDictionary* params) {
    NSMutableDictionary* newParams = [@{
            makeCDDAKeyName(@"testGroup"): getTestGroup(),
            makeCDDAKeyName(@"isUnlimitedFunctionalityUnlocked"): @(
                    (int) isUnlimitedFunctionalityUnlocked()),
    } mutableCopy];
    [params enumerateKeysAndObjectsUsingBlock:^(NSString* key, id value, bool* stop) {
        [newParams
                setValue:value
                forKey:makeCDDAKeyName(key)
        ];
    }];
    [FIRAnalytics logEventWithName:makeCDDAKeyName(name) parameters:newParams];
}
