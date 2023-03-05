//
//  AppDelegate.h
//  SDLPlayground2
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDLUIKitDelegate : NSObject<UIApplicationDelegate>
- (void)hideLaunchScreen;
@end

@interface AppDelegate : SDLUIKitDelegate

@property UIWindow* launchWindow;

@end
