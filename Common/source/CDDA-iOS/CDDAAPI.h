//
//  CDDAAPI.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 17.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef CDDAAPI_h
#define CDDAAPI_h

#import <Foundation/Foundation.h>
#import "PaywallDisplayEventSubscriberDelegate.h"

namespace CDDAAPI
{
typedef void (void_f)();
typedef bool (subscribeDisplayingPaywallToCDDAEvents_f)(id<PaywallDisplayEventSubscriberDelegate>);
extern void_f* returnToMainMenu_ptr;
extern subscribeDisplayingPaywallToCDDAEvents_f* subscribeDisplayingPaywallToCDDAEvents_ptr;
};

#endif /* CDDAAPI_h */
