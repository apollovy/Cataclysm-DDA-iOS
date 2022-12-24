//
// Created by Аполлов Юрий Андреевич on 11.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FirebaseAnalytics/FirebaseAnalytics.h>

#include "event.h"
#import "event_bus.h"
#import "game.h"

#import "../Paywall/showPaywall.h"
#include "PaywallDisplay.h"

extern "C" {
#import "cdda_firebase.h"
#import "logAnalytics.h"
#import "PaywallUnlimitedFunctionality.h"
}


NSString* eventsCountKey = @"eventCount";

NSInteger getEventsCount() {
    return [NSUserDefaults.standardUserDefaults integerForKey:eventsCountKey];
}

void incrementEventsCount() {
    [NSUserDefaults.standardUserDefaults setInteger:getEventsCount() + 1 forKey:eventsCountKey];
}

NSDictionary* testGroupToEventsCount = @{
        @"1": @10,
        @"2": @20,
};

bool showPaywallIfPlayedEnough() {
    auto eventsCount = getEventsCount();
    auto testGroup = getTestGroup();
    NSNumber* maxEventsCount = testGroupToEventsCount[testGroup];
    if (maxEventsCount == NULL) {
        NSLog(@"Unknown test group %@", testGroup);
    }
    if (eventsCount >= [maxEventsCount longValue] && !isUnlimitedFunctionalityUnlocked()) {
        logAnalytics(@"paywall_shown", @{
                @"cdda_test_group": testGroup,
        });
        showPaywall();
        return true;
    }
    return false;
}

void logAnalyticsEventForEventType(NSString* name, event_type eventType) {
    logAnalytics(name, @{
                    @"cdda_event_type": [NSString stringWithFormat:@"%s",
                                                                   io::enum_to_string(eventType).data()],
                    @"cdda_events_count": @(getEventsCount()),
            }
    );
};

class PaywallDisplay : public event_subscriber {
    void notify(const cata::event &event) {
        event_type eventType = event.type();
        switch (eventType) {
            case event_type::avatar_moves:
            case event_type::character_takes_damage:
            case event_type::character_heals_damage: {
                logAnalyticsEventForEventType(@"paywall_event_not_counted", eventType);
                showPaywallIfPlayedEnough();
                break;
            }
            default: {
                logAnalyticsEventForEventType(@"paywall_event_counted", eventType);
                incrementEventsCount();
                showPaywallIfPlayedEnough();
                break;
            }
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
