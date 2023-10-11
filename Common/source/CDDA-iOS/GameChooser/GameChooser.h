//
//  GameChooser.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 11.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef GameChooser_h
#define GameChooser_h
#import <UIKit/UIKit.h>

@protocol ChosenDelegate

- (void)firstChosen:(id)sender;
- (void)secondChosen:(id)sender;

@end

@interface ChosenDelegate : NSObject<ChosenDelegate>
@end

@protocol GameChooserControllerInitializer

- (void)initialize:(UIViewController*)controller;

@end

@interface GameChooserControllerInitializer : NSObject<GameChooserControllerInitializer>

- (id)init:(id<ChosenDelegate>)chosenDelegate;

@end

#endif /* GameChooser_h */
