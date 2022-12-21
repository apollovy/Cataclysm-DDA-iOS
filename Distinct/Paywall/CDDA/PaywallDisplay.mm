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


class PaywallDisplay : public event_subscriber {
    void notify(const cata::event &event) {
        switch (event.type()) {
            case event_type::character_kills_monster:
            case event_type::character_kills_character: {
                showPaywall();
                break;
            }
            default:
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
