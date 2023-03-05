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

@interface GamePadViewController : UIViewController <UIGestureRecognizerDelegate>

-(IBAction)toggleMenu:(MenuButton*)sender;
@property (weak, nonatomic) IBOutlet UIView* menusView;
-(IBAction)pressKey:(MenuButton*)sender;
-(IBAction)holdGamepadButton:(UILongPressGestureRecognizer*)sender;
-(IBAction)tapGamepadButton:(UITapGestureRecognizer*)sender;
-(IBAction)pageUpDown:(PageUpDownPanGestureRecognizer*)sender;
-(IBAction)temporarilyHideUI:(UILongPressGestureRecognizer*)sender;
-(IBAction)showAndFixMenu:(ShowAndFixGestureRecognizer*)sender;

@end

NS_ASSUME_NONNULL_END
