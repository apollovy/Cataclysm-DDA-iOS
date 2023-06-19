//
//  main.c
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#include "CDDA_main_patch.h"
#include "../../../../worktree/Cataclysm-DDA/0.G/src/main.cpp"

extern "C" {
int CDDA_main(int argc, char** argv) {
    return CDDA_main(argc, (const char**)argv);
}
}
