//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "PaywallController.h"


@implementation PaywallController : UIViewController {
    SKProductsRequest* _productRequest;
}

- (IBAction)buy:(id)sender {
    NSString* productIdentifier = [self _getProductIdentifier];
    NSLog(@"%@", productIdentifier);

    _productRequest = [
            [SKProductsRequest new]
                               initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]
    ];

    _productRequest.delegate = self;
    [_productRequest start];
}

- (NSString*)_getProductIdentifier {
    NSURL* url = [[NSBundle mainBundle]
                            URLForResource:@"UnlimitedGameIAPID" withExtension:@"plist"];
    NSString* productIdentifier = [NSArray arrayWithContentsOfURL:url error:NULL][0];
    return productIdentifier;
}

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {
    _productRequest = NULL;
    if (response.invalidProductIdentifiers.count > 0) {
        NSLog(@"No valid purchase identifier found! Invalid ones: %@",
                response.invalidProductIdentifiers);
        return;
    }

    SKProduct* product = response.products.firstObject;
    NSLog(@"%@%@", product.price, product.priceLocale.currencySymbol);
}

@end
