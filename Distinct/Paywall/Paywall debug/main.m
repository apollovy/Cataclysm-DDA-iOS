//
//  main.m
//  Paywall debug
//
//  Created by Аполлов Юрий Андреевич on 21.12.2022.
//  Copyright © 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "cdda_firebase.h"


int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    configureFirebase();
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}