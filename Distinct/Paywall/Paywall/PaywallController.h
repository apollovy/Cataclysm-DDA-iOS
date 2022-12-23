//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>


@interface PaywallController : UIViewController <SKProductsRequestDelegate>

- (IBAction)buy:(id)sender;
@property IBOutlet UILabel* priceLabel;

@end
