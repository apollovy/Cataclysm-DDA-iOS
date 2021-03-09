//
//  ViewController.m
//  SDLPlayground2
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "path_utils.h"
#import "CDDA_iOS_main.h"

#import "ViewController.h"


@implementation ViewController

- (IBAction)startApp:(id)sender
{
    self.view.window.hidden = YES;
    self.view = nil;
    CDDA_iOS_main(getDocumentPath());
}

@end
