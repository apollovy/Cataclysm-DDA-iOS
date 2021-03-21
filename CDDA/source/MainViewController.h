//
//  MainViewController.h
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UIViewController

- (IBAction)startApp:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)load:(id)sender;

@property IBOutlet UIView* buttons;

@property IBOutlet UIView* progressWrapper;
@property IBOutlet UILabel* label;
@property IBOutlet UIProgressView* progressView;

@end
