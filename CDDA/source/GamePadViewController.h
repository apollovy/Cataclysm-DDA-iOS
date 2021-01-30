//
//  GamePadViewController.h
//  SdlPlayground
//
//  Created by Аполлов Юрий Андреевич on 03/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDDA-Swift.h"


NS_ASSUME_NONNULL_BEGIN

@interface GamePadViewController : UIViewController

-(IBAction)toggleMenu:(MenuButton*)sender;
@property (weak, nonatomic) IBOutlet UIView* menusView;
-(IBAction)pressKey:(MenuButton*)sender;

@end

NS_ASSUME_NONNULL_END
