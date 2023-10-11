//
//  SimpleChosenDelegate.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 12.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//
#import "GameChooser.h"


@implementation ChosenDelegate

- (void)firstChosen:(id)sender
{
    NSLog(@"First chosen.");
}

- (void)secondChosen:(id)sender
{
    NSLog(@"Second chosen.");
}

@end
