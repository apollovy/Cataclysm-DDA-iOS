//
//  GameChooserViewControllerInitializerFactory.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 12.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef GameChooserControllerInitializerFactory_h
#define GameChooserControllerInitializerFactory_h

#import "UIViewControllerInitializer.h"

@protocol UIViewControllerInitializerFactory

- (id<UIViewControllerInitializer>)create;

@end
#endif /* GameChooserControllerInitializerFactory_h */
