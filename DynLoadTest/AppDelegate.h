//
//  AppDelegate.h
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDLUIKitDelegate : NSObject<UIApplicationDelegate>
- (void)hideLaunchScreen;
@end
//
@interface AppDelegate : SDLUIKitDelegate
//@interface AppDelegate : NSObject<UIApplicationDelegate>

@property UIWindow* launchWindow;

@end
