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

- (void)viewDidLoad {
    NSString* productIdentifier = [self _getProductIdentifier];

    _productRequest = [[SKProductsRequest new]
                                          initWithProductIdentifiers:[NSSet setWithObject:productIdentifier]
    ];

    _productRequest.delegate = self;
    [_productRequest start];
}


- (IBAction)buy:(id)sender {
    NSLog(@"Buy pressed");
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.priceLabel
                setText:[NSString
                        stringWithFormat:@"%@%@", product.priceLocale.currencySymbol, product.price
                ]];
    });
}

@end
