//
//  ViewController.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import "GameChooser.h"
#import "GameChooserViewController.h"

@implementation GameChooserViewController
{
    GameChooserControllerInitializer* _initializer;
}

-(void)viewWillAppear:(BOOL)animated
{
    _initializer = [[GameChooserControllerInitializer new] init:[ChosenDelegate new]];
    [_initializer initialize:self];
}

@end
