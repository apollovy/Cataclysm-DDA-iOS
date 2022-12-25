//
// Created by Аполлов Юрий Андреевич on 21.12.2022.
// Copyright (c) 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PaywallController.h"

#import "showPaywall.h"

void showPaywall() {
    PaywallController* controller = [[UIStoryboard storyboardWithName:@"Paywall"
                                                   bundle:nil]
                                                   instantiateInitialViewController];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    UIWindow* window = [[UIApplication.sharedApplication windows] firstObject];
    [window.rootViewController showViewController:controller sender:nil];
}
