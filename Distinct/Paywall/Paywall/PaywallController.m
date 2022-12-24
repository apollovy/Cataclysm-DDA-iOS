//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "PaywallController.h"

#import "PaywallPaymentKey.h"
#import "PaywallUnlimitedFunctionality.h"
#import "logAnalytics.h"


@implementation PaywallController {
    SKProductsRequest* _productRequest;
    SKProduct* _product;
}

# pragma mark price loading

- (void)viewDidLoad {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    NSString* productIdentifier = [self _getProductIdentifier];

    _productRequest = [[SKProductsRequest
            new]
            initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]
    ];

    _productRequest.delegate = self;
    [_productRequest start];
}

- (NSString*)_getProductIdentifier {
    NSURL* url = [[NSBundle mainBundle]
                            URLForResource:(NSString*) PaywallPaymentKey withExtension:@"plist"];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSString* productIdentifier = [NSArray arrayWithContentsOfURL:url][0];
#pragma clang diagnostic pop
    return productIdentifier;
}

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {
    _productRequest = NULL;
    if (response.invalidProductIdentifiers.count > 0) {
        [self
                logAnalyticsEvent:@"no_valid_identifiers_found"
                withParams:@{
                        @"invalidIdentifiers": response.invalidProductIdentifiers
                }
        ];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.priceLabel setText:@"NOT FOUND!"];
        });
        return;
    }

    _product = response.products.firstObject;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.priceLabel
                setText:[NSString
                        stringWithFormat:@"%@%@",
                                         self->_product.priceLocale.currencySymbol,
                                         self->_product.price
                ]
        ];
        self.buyButton.enabled = true;
    });
}

# pragma mark purchase handling

- (IBAction)buy:(id)sender {
    [self logAnalyticsEvent:@"tried" withParams:@{}];
    self.buyButton.enabled = false;
    SKPayment* payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
    for (SKPaymentTransaction* transaction in transactions) {
        switch (transaction.transactionState) {
            // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
//                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
//                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed: {
                NSString* error = transaction.error.localizedFailureReason
                        ?: transaction.error.localizedDescription
                                ?: [NSString
                                        stringWithFormat:@"%ld@%@",
                                                         transaction.error.code,
                                                         transaction.error.domain
                                ];
                [self
                        logAnalyticsEvent:@"failed"
                        withParams:@{
                                @"error": error
                        }
                ];
                self.buyButton.enabled = true;
                break;
            }
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored: {
                NSString* eventName = transaction
                        .transactionState == SKPaymentTransactionStatePurchased
                        ? @"succeeded"
                        : @"restored";
                [self
                        logAnalyticsEvent:eventName
                        withParams:@{
                                @"transactionId": transaction.transactionIdentifier,
                        }
                ];
                [self completeTransaction];
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
    [self finishWithPaywall];
}

- (void)finishWithPaywall {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self dismissViewControllerAnimated:true completion:NULL];
}

#pragma mark analytics

- (void)logAnalyticsEvent:(NSString*)name withParams:(NSDictionary*)params {
    logAnalytics([NSString stringWithFormat:@"paywall_purchase_%@", name], params);
}

@end
