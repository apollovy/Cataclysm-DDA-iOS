//
//  ChosenDelegate.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 12.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef ChosenDelegate_h
#define ChosenDelegate_h

@protocol ChosenDelegate

- (void)firstChosen:(id)sender;
- (void)secondChosen:(id)sender;

@end

#endif /* ChosenDelegate_h */
