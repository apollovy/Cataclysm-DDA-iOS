//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "PaywallController.h"
#import "PaywallPaymentKey.h"
#import "PaywallUnlimitedFunctionality.h"


@implementation PaywallController : UIViewController {
    SKProductsRequest* _productRequest;
    SKProduct* _product;
}

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

- (IBAction)buy:(id)sender {
    self.buyButton.enabled = false;
    // TODO: Show "Processing" screen
    SKPayment* payment = [SKPayment paymentWithProduct:_product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (NSString*)_getProductIdentifier {
    NSURL* url = [[NSBundle mainBundle]
                            URLForResource:(NSString*) PaywallPaymentKey withExtension:@"plist"];
    NSString* productIdentifier = [NSArray arrayWithContentsOfURL:url][0];
    return productIdentifier;
}

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {
    _productRequest = NULL;
    if (response.invalidProductIdentifiers.count > 0) {
        NSLog(@"No valid purchase identifier found! Invalid ones: %@",
                response.invalidProductIdentifiers);
        return;
    }


    _product = response.products.firstObject;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.priceLabel
                setText:[NSString stringWithFormat:@"%@%@",
                                                   _product.priceLocale.currencySymbol,
                                                   _product.price
                ]];
        self.buyButton.enabled = true;
    });
}

- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)transactions {
    NSLog(@"- (void)paymentQueue:(SKPaymentQueue*)queue updatedTransactions:(NSArray*)"
          "transactions {");
    for (SKPaymentTransaction* transaction in transactions) {
        switch (transaction.transactionState) {
            // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
//                [self showTransactionAsInProgress:transaction deferred:NO];
                break;
            case SKPaymentTransactionStateDeferred:
//                [self showTransactionAsInProgress:transaction deferred:YES];
                break;
            case SKPaymentTransactionStateFailed:
//                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchased:
            case SKPaymentTransactionStateRestored:
                [self completeTransaction];
                break;
            default:
                // For debugging
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

- (void)completeTransaction {
    NSLog(@"- (void)completeTransaction {");
    unlockUnlimitedFunctionality();
    [self finishWithPaywall];
}

- (void)finishWithPaywall {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self dismissViewControllerAnimated:true completion:NULL];
}

@end
