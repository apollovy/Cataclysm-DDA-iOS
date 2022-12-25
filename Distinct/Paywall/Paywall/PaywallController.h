//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//
#pragma once
#ifndef PaywallControllerH
#define PaywallControllerH

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "CDDA-Swift.h"

@interface PaywallController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property IBOutlet PaywallBuyArea* paywallBuyArea;
@end

#endif  // PaywallControllerH

