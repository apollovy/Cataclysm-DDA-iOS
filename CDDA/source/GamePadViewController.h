//
//  GamePadViewController.h
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JSButton.h"


NS_ASSUME_NONNULL_BEGIN

@interface GamePadViewController : UIViewController

@property (nonatomic, weak) IBOutlet JSButton* escapeButton;

@end

NS_ASSUME_NONNULL_END
