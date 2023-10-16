//
//  getCDDARunArgs.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 16.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef getCDDARunArgs_h
#define getCDDARunArgs_h

#include <tuple>

std::tuple<int, char**>getCDDARunArgs(NSString* documentPath);

#endif /* getCDDARunArgs_h */
