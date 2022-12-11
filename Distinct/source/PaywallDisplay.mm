//
// Created by Аполлов Юрий Андреевич on 11.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

#include "event.h"
#import "event_bus.h"
#import "game.h"

#include "PaywallDisplay.h"


class PaywallDisplay : public event_subscriber {
    void notify(const cata::event &event) {
        switch (event.type()) {
            case event_type::character_kills_monster:
            case event_type::character_kills_character: {
                NSLog(@"Character killed monster.");
                break;
            }
            default:
                break;
        }
    }
};

PaywallDisplay* paywallDisplay;

void subscribe() {
    paywallDisplay = new PaywallDisplay();
    g->events().subscribe(paywallDisplay);
}
