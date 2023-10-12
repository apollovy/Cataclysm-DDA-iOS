//
//  GameChooserViewControllerInitializer.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 12.10.2023.
//  Copyright © 2023 Аполлов Юрий Андреевич. All rights reserved.
//

#ifndef GameChooserViewControllerInitializer_h
#define GameChooserViewControllerInitializer_h

#import <UIKit/UIKit.h>

@protocol UIViewControllerInitializer

- (void)initialize:(UIViewController*)controller;

@end

#endif /* GameChooserViewControllerInitializer_h */
