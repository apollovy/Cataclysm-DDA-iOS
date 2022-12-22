//
// Created by Аполлов Юрий Андреевич on 11.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "event.h"
#import "event_bus.h"
#import "game.h"

#import "../Paywall/showPaywall.h"
#include "PaywallDisplay.h"

extern "C" {
#import "cdda_firebase.h"
}


NSString* killCountKey = @"killCount";

NSInteger getKillCount() {
    return [NSUserDefaults.standardUserDefaults integerForKey:killCountKey];
}

void incrementKillCount() {
    [NSUserDefaults.standardUserDefaults setInteger:getKillCount()+1 forKey:killCountKey];
}

NSDictionary* testGroupToKillCount = @{
        @"1": @10,
        @"2": @5,
};

bool showPaywallIfKilledEnough() {
    auto killCount = getKillCount();
    auto testGroup = getTestGroup();
    NSNumber* maxKillCount = testGroupToKillCount[testGroup];
    if (maxKillCount == NULL) {
        NSLog(@"Unknown test group %@", testGroup);
    }
    if (killCount >= [maxKillCount longValue]) {
        showPaywall();
        return true;
    }
    return false;
}

class PaywallDisplay : public event_subscriber {
    void notify(const cata::event &event) {
        switch (event.type()) {
            case event_type::character_kills_monster:
            case event_type::character_kills_character: {
                if (!showPaywallIfKilledEnough()) {
                    incrementKillCount();
                }
                break;
            }
            default:
                showPaywallIfKilledEnough();
                break;
        }
    }
};

PaywallDisplay* paywallDisplay;

bool subscribe() {
    if (paywallDisplay == NULL) {
        paywallDisplay = new PaywallDisplay();
    }
    if (g != NULL) {
        event_bus* events = &(g->events());
        if (events != NULL) {
            events->subscribe(paywallDisplay);
            return true;
        }
    }
    return false;
}
