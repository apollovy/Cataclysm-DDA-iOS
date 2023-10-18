//
// Created by Аполлов Юрий Андреевич on 11.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef subscribeDisplayingPaywallToCDDAEvents_H
#define subscribeDisplayingPaywallToCDDAEvents_H

#import <Foundation/Foundation.h>
#import "PaywallDisplayEventSubscriberDelegate.h"

#ifdef __cplusplus
extern "C" {
#endif

bool CDDAAPI_subscribeDisplayingPaywallToCDDAEvents(id<PaywallDisplayEventSubscriberDelegate> delegate);

#ifdef __cplusplus
};
#endif

#endif //subscribeDisplayingPaywallToCDDAEvents_H
