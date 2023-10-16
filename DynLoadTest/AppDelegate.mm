//
//  AppDelegate.m
//  DynLoadTest
//
//  Created by Аполлов Юрий Андреевич on 19.06.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <tuple>
#import "AppDelegate.h"
#import "CDDA_main.h"
#import "getCDDARunArgs.h"

extern "C" {
#import "path_utils.h"
}

@implementation AppDelegate
- (void)postFinishLaunch
{
    auto cDDARunArgs = getCDDARunArgs(getDocumentURL().path);
    CDDA_main(std::get<0>(cDDARunArgs), std::get<1>(cDDARunArgs));
}

@end
