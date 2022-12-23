//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "PaywallPaymentKey.h"

void unlockUnlimitedFunctionality(void) {
    [NSUserDefaults.standardUserDefaults setBool:true forKey:(NSString*) PaywallPaymentKey];
}

bool isUnlimitedFunctionalityUnlocked(void) {
    return [NSUserDefaults.standardUserDefaults boolForKey:(NSString*) PaywallPaymentKey];
}
