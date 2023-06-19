//
//  main.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
