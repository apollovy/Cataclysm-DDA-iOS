//
//  ViewController.m
//  Paywall debug
//
//  Created by Аполлов Юрий Андреевич on 22.12.2022.
//  Copyright © 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

#import "showPaywall.h"

#import "ViewController.h"


@implementation ViewController : UIViewController {
    
}

-(IBAction)showMain:(UIStoryboardSegue*)segue {
}

-(IBAction)showPaywall:(id)sender {
    showPaywall();
}

@end
