//
//  PaywallControllerCloseDelegate.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 26.12.2022.
//  Copyright © 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "PaywallControllerCloseDelegate.h"

@implementation PaywallControllerCloseDelegate {
}

-(void) close:(UIViewController*)controller {
    [controller dismissViewControllerAnimated:true completion:NULL];
}

@end
