//
//  SimpleChosenDelegate.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 12.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//
#import "IndependentChosenDelegate.h"
#import <Foundation/Foundation.h>

@implementation IndependentChosenDelegate

- (void)firstChosen:(id)sender
{
    NSLog(@"First chosen.");
}

- (void)secondChosen:(id)sender
{
    NSLog(@"Second chosen.");
}

@end
