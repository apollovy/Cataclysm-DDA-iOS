//
//  GameChooserControllerInitializer.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 11.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameChooser.h"
#import "GameChooserView.h"

@implementation GameChooserControllerInitializer
{
    id<ChosenDelegate> _chosenDelegate;
}

- (id)init:(id<ChosenDelegate>)chosenDelegate
{
    self->_chosenDelegate = chosenDelegate;
    return self;
}

- (void)initialize:(UIViewController *)controller {
    GameChooserView* gameChooserView = [[[NSBundle mainBundle] loadNibNamed:@"GameChooser" owner:nil options:nil] lastObject];
    [gameChooserView.first addTarget:_chosenDelegate action:@selector(firstChosen:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [gameChooserView.second addTarget:_chosenDelegate action:@selector(secondChosen:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [controller setView:gameChooserView];
}

@end
