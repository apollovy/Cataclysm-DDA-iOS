//
//  SimpleGameChooserViewControllerInitializerFactory.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 12.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IndependentUIViewControllerInitializerFactory.h"
#import "UIViewControllerInitializer.h"
#import "ChosenDelegateUIViewControllerInitializer.h"
#import "IndependentChosenDelegate.h"

@implementation IndependentUIViewControllerInitializerFactory

- (id<UIViewControllerInitializer>)create
{
    return [[ChosenDelegateUIViewControllerInitializer new] init:[IndependentChosenDelegate new]];

}

@end
