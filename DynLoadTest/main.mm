//
//  main.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <SDL_main.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "globalWindow.h"

#import <tuple>
#import "AppDelegate.h"
#import "CDDA_main.h"
#import "getCDDARunArgs.h"

extern "C" {
#import "path_utils.h"
}
#import "globalWindow.h"

UIWindow* globalWindow;
BOOL ready = false;
void setReady(BOOL rdy)
{
    ready = rdy;
}

int main(int argc, char** argv)
{
    auto ctl = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    globalWindow = [UIWindow new];
    globalWindow.rootViewController = ctl;
    [globalWindow makeKeyAndVisible];
    while (!ready) {
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1, true);
    }
    globalWindow.hidden = @YES;
    auto cDDARunArgs = getCDDARunArgs(getDocumentURL().path);
    return CDDA_main(std::get<0>(cDDARunArgs), std::get<1>(cDDARunArgs));
}
