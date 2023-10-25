//
//  DefaultCDDAUIAdaptor.m
//  CBNFramework
//
//  Created by Аполлов Юрий Андреевич on 19.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultCDDAUIAdaptor.h"

#import "ui_manager.h"
#import "options.h"

extern void resize_term( const int cell_w, const int cell_h );

@implementation DefaultCDDAUIAdaptor
{
    std::unique_ptr<ui_adaptor> _uiAdaptor;
}

+(instancetype)new
{
    auto obj = [super new];
    obj->_uiAdaptor = std::make_unique<ui_adaptor>();
    return obj;
}

- (void)resizeToFullScreenOnScreenResize {
    _uiAdaptor->on_screen_resize( [&]( ui_adaptor & ui ) {
        resize_term(get_option<int>( "TERMINAL_X" ), get_option<int>( "TERMINAL_Y" ));
    });
}

- (void)doNothingOnScreenResize {
    _uiAdaptor->on_screen_resize( [&]( ui_adaptor & ui ){});
}


@end

extern "C"
{
    DefaultCDDAUIAdaptor* CDDAAPI_createUIAdapter()
    {
        return [DefaultCDDAUIAdaptor new];
    }
}
