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

// special keys
@property (nonatomic, weak) IBOutlet JSButton* escapeButton;
@property (nonatomic, weak) IBOutlet JSButton* returnButton;
@property (nonatomic, weak) IBOutlet JSButton* tabButton;
@property (nonatomic, weak) IBOutlet JSButton* backtabButton;

// small letters
@property (nonatomic, weak) IBOutlet JSButton* aButton;
@property (nonatomic, weak) IBOutlet JSButton* cButton;
@property (nonatomic, weak) IBOutlet JSButton* dButton;
@property (nonatomic, weak) IBOutlet JSButton* eButton;
@property (nonatomic, weak) IBOutlet JSButton* fButton;
@property (nonatomic, weak) IBOutlet JSButton* iButton;
@property (nonatomic, weak) IBOutlet JSButton* mButton;
@property (nonatomic, weak) IBOutlet JSButton* rButton;
@property (nonatomic, weak) IBOutlet JSButton* sButton;
@property (nonatomic, weak) IBOutlet JSButton* tButton;
@property (nonatomic, weak) IBOutlet JSButton* wButton;

// punctuation
@property (nonatomic, weak) IBOutlet JSButton* dotButton;
@property (nonatomic, weak) IBOutlet JSButton* slashButton;

// digits
@property (nonatomic, weak) IBOutlet JSButton* _1Button;
@property (nonatomic, weak) IBOutlet JSButton* _2Button;
@property (nonatomic, weak) IBOutlet JSButton* _3Button;
@property (nonatomic, weak) IBOutlet JSButton* _4Button;
@property (nonatomic, weak) IBOutlet JSButton* _5Button;
@property (nonatomic, weak) IBOutlet JSButton* _6Button;
@property (nonatomic, weak) IBOutlet JSButton* _7Button;
@property (nonatomic, weak) IBOutlet JSButton* _8Button;
@property (nonatomic, weak) IBOutlet JSButton* _9Button;

@end

NS_ASSUME_NONNULL_END
