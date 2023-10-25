//
//  StoreObserver.m
//  CBNfreeIAP
//
//  Created by Аполлов Юрий Андреевич on 20.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "StoreObserver.h"

extern "C"
{
#import "getPaywallConfig.h"
#import "logAnalytics.h"
#import "PaywallUnlimitedFunctionality.h"
}

@implementation StoreObserver

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
    auto config = getPaywallConfig();
    NSArray<NSString*>* unlockingProductIdentifiers = config[@"UnlockingProductIdentifiers"];
    
    for (SKPaymentTransaction* transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
            case SKPaymentTransactionStateDeferred:
            case SKPaymentTransactionStateFailed: {
                break;
            }
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored: {
                NSString* eventName = transaction
                    .transactionState == SKPaymentTransactionStatePurchased
                ? @"succeeded"
                : @"restored";
                if ([unlockingProductIdentifiers containsObject:transaction.payment.productIdentifier])
                {
                    [self
                     logAnalyticsEvent:eventName
                     withParams:@{
                        @"transactionId": transaction.transactionIdentifier,
                    }
                    ];
                    [self completeTransaction];
                }
                break;
            }
            default: {
                NSString* message = @"unexpected_transaction_state";
                int transactionState = transaction.transactionState;
                NSLog(@"%@%d", message, transactionState);
                [self
                 logAnalyticsEvent:message
                 withParams:@{
                    @"state": [NSString
                               stringWithFormat:@"%d",
                               transactionState
                    ]
                }];
                break;
            }
        }
    }
}

- (void)completeTransaction {
    unlockUnlimitedFunctionality();
}

- (void)logAnalyticsEvent:(NSString*)name withParams:(NSDictionary*)params {
    logAnalytics([NSString stringWithFormat:@"paywall_purchase_root_%@", name], params);
}

@end
