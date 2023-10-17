//
//  getCataclysmFlavor.m
//  CBNfreeIAP
//
//  Created by Аполлов Юрий Андреевич on 13.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "getCataclysmFlavor.h"


@interface CataclysmFlavorKeeper : NSObject

@property NSString* flavor;

@end

@implementation CataclysmFlavorKeeper
@end

static CataclysmFlavorKeeper* _keeper = [CataclysmFlavorKeeper new];
NSString* getCataclysmFlavor(void)
{
    return _keeper.flavor;
}
void setCataclysmFlavor(NSString* flavor)
{
    _keeper.flavor = flavor;
}
