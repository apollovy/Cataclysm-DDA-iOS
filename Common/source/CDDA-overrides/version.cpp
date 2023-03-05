//
//  version.cpp
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 04.08.2022.
//  Copyright © 2022 Аполлов Юрий Андреевич. All rights reserved.
//

#include <stdio.h>

#include "get_version.h" // IWYU pragma: associated

#include "version.h"

const char *getVersionString()
{
    return VERSION;
}
