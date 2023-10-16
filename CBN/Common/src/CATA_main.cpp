//
//  CATA_main.cpp
//  CBNFramework
//
//  Created by Аполлов Юрий Андреевич on 16.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#include <stdio.h>

#define main CATA_main_func
#import "../../worktree/Cataclysm-BN/src/main.cpp"

extern "C"
{
int CATA_main(int argc, char* argv[])
{
    return CATA_main_func(argc, argv);
}
}
