//
//  getCataclysmFlavor.m
//  CBNfreeIAP
//
//  Created by Аполлов Юрий Андреевич on 13.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "getCataclysmFlavor.h"


NSString* getCataclysmFlavor(void)
{
    BOOL runDDA = [NSUserDefaults.standardUserDefaults boolForKey:@"runDDA"];
    return runDDA ? @"CDDA0G" : @"CBN";
}
