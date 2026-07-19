//
//  CDDAAPI.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 17.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef CDDAAPI_h
#define CDDAAPI_h

#import <Foundation/Foundation.h>
#import "CDDAUIAdaptor.h"

namespace CDDAAPI
{
typedef void (void_f)();
extern void_f* returnToMainMenu_ptr;

typedef id<CDDAUIAdaptor>(createUIAdapter_f)();
extern createUIAdapter_f* createUIAdapter_ptr;
};

#endif /* CDDAAPI_h */
