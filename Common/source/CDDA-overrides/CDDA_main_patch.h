//
//  main_patch.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.03.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef main_patch_h
#define main_patch_h

#define main CDDA_main

extern "C" {
void no_exit(__attribute__((unused)) int status){}
}

#define exit no_exit
//#include "runtime_handlers.h"


#endif /* main_patch_h */
