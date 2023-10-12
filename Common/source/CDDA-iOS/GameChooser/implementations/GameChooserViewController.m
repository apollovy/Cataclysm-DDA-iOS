//
//  ViewController.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import "GameChooserViewController.h"
#import "UIViewControllerInitializer.h"
#import "IndependentUIViewControllerInitializerFactory.h"

@implementation GameChooserViewController
{
    id<UIViewControllerInitializer> _initializer;
}

-(void)viewWillAppear:(BOOL)animated
{
    _initializer = [[IndependentUIViewControllerInitializerFactory new] create];
    [_initializer initialize:self];
}

@end
