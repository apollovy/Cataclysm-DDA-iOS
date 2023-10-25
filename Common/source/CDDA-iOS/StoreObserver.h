//
//  StoreObserver.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 20.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef StoreObserver_h
#define StoreObserver_h
#import <StoreKit/StoreKit.h>

@interface StoreObserver : NSObject<SKPaymentTransactionObserver>

@end

#endif /* StoreObserver_h */
