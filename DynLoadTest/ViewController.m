//
//  ViewController.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import "ViewController.h"
#import "GameChooserView.h"

@implementation ViewController
{
    GameChooserView* _gameChooserView;
}

-(void)viewWillAppear:(BOOL)animated
{
    _gameChooserView = [[[NSBundle mainBundle] loadNibNamed:@"GameChooser" owner:nil options:nil] lastObject];
    [self->_gameChooserView.first addTarget:self action:@selector(firstChosen:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self->_gameChooserView.second addTarget:self action:@selector(secondChosen:) forControlEvents:UIControlEventPrimaryActionTriggered];
    [self setView:_gameChooserView];
}

- (void)firstChosen:(id)sender
{
    NSLog(@"First chosen.");
}

- (void)secondChosen:(id)sender
{
    NSLog(@"Second chosen.");
}

@end
