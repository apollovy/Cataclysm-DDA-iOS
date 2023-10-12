//
//  ChosenDelegateGameChooserControllerInitializer.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 12.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef ChosenDelegateGameChooserControllerInitializer_h
#define ChosenDelegateGameChooserControllerInitializer_h

#import "UIViewControllerInitializer.h"
#import "ChosenDelegate.h"

@interface ChosenDelegateUIViewControllerInitializer : NSObject<UIViewControllerInitializer>

- (id)init:(id<ChosenDelegate>)chosenDelegate;

@end

#endif /* ChosenDelegateGameChooserControllerInitializer_h */
