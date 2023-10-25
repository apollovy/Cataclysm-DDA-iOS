//
//  NoopStoreObserverDelegate.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 26.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StoreObserverDelegate.h"
#import "NoopStoreObserverDelegate.h"

@implementation NoopStoreObserverDelegate
- (void)completeTransaction {
    // nothing
}

- (void)handleTransactionFailure:(nonnull SKPaymentTransaction *)transaction {
    // nothing

}

@end
