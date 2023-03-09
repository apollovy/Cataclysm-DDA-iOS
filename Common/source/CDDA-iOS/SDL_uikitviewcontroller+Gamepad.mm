#import <__wctype.h>
//
// Created by Аполлов Юрий Андреевич on 17.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <iostream>

#if !defined(DCSS_IOS)
#import "options.h"
#import "ui_manager.h"
#endif

#import "SDL_char_utils.h"

#import "SDL_uikitviewcontroller+Gamepad.h"
#import "GamePadViewController.h"
#import "game_dependent.h"
#import "MainViewController.h"


extern bool resize_term(int, int);


#pragma mark - OnKeyboardHandler

@interface OnKeyboardHandler : NSObject

@property (weak, nonatomic) SDL_uikitviewcontroller* _controller;

@end

@implementation OnKeyboardHandler

+(id)initWithController:(SDL_uikitviewcontroller*)controller
{
    OnKeyboardHandler* obj = [OnKeyboardHandler new];
    obj._controller = controller;
    
    return obj;
}

-(void)onKeyboard
{
    CGSize size = self._controller.view.window.frame.size;
    size.height = size.height - self._controller.keyboardHeight;
    [self._controller resizeRootView];
    [self._controller maybeUpdateFrameTo:size];
}

@end


@interface GestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

+(id)initWith:(UIGestureRecognizer*)first and:(UIGestureRecognizer*)second;

@end


@implementation GestureRecognizerDelegate
{
    UIGestureRecognizer* _first;
    UIGestureRecognizer* _second;
}

+(instancetype)initWith:(UIGestureRecognizer*)first and:(UIGestureRecognizer*)second
{
    GestureRecognizerDelegate* obj = [GestureRecognizerDelegate new];
    obj->_first = first;
    obj->_second = second;
    
    return obj;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (((gestureRecognizer == self->_first) && (otherGestureRecognizer == self->_second)) || ((gestureRecognizer == self->_second) && (otherGestureRecognizer == self->_first)))
        return YES;
    else
        return NO;
}

@end


typedef struct PanViewHelperReturnType {
    NSString* movementText;
    CGFloat newCoorinate;
} PanViewHelperReturnType;


@interface KeyboardSwipeGestureRecognizer : UISwipeGestureRecognizer

@end


@implementation KeyboardSwipeGestureRecognizer

NSDate* _startDate;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    _startDate = [NSDate date];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_startDate.timeIntervalSinceNow < -[NSUserDefaults.standardUserDefaults doubleForKey:@"keyboardSwipeTime"])
        self.state = UIGestureRecognizerStateFailed;
    else
        [super touchesMoved:touches withEvent:event];
}

@end


#pragma mark - SDL_uikitviewcontroller (Gamepad)

@implementation SDL_uikitviewcontroller (Gamepad)

const NSArray<NSString*>* _observedSettings = @[@"overlayUIEnabled", @"panningWith1Finger", @"screenAutoresize"];

#if !defined(DCSS_IOS)
std::unique_ptr<ui_adaptor> _uiAdaptor;
#endif

- (void)viewDidAppear:(BOOL)animated {
    _onKeyboardHandler = [OnKeyboardHandler initWithController:self];
#if !defined(DCSS_IOS)
    _uiAdaptor = std::make_unique<ui_adaptor>();
#endif

    for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification,  UIApplicationDidBecomeActiveNotification, UIApplicationWillResignActiveNotification])
        [[NSNotificationCenter defaultCenter] addObserver:_onKeyboardHandler selector:@selector(onKeyboard) name:notification object:nil];

    for (NSString* keyPath in _observedSettings)
        [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:nil];

    [self resizeRootView];
    UIWindow* window = [[UIApplication.sharedApplication windows] firstObject];
    window.rootViewController = self;
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *vc = [sb instantiateInitialViewController];
    [self presentViewController:vc animated:YES completion:NULL];
}

- (void)viewWillDisappear:(BOOL)animated
{
    for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification,  UIApplicationDidBecomeActiveNotification, UIApplicationWillResignActiveNotification])
        [[NSNotificationCenter defaultCenter] removeObserver:_onKeyboardHandler name:notification object:nil];
    _onKeyboardHandler = nil;
    _gamepadViewController = nil;

    @try {
        for (NSString* keyPath in _observedSettings)
            [NSUserDefaults.standardUserDefaults removeObserver:self forKeyPath:keyPath context:nil];
    } @catch (NSException *exception) {
        NSLog(@"Failed to remove the observer: %@", exception);
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual: @"overlayUIEnabled"])
        [self maybeToggleUI];
    else if ([keyPath isEqual:@"panningWith1Finger"])
        [self addRecognizers];
    else if ([keyPath isEqual:@"screenAutoresize"])
        [self toggleScreenAutoresize];
    else
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


// determined empirically, on lesser sizes main menu run away screaming
static CGSize _minSize = {632, 368};

- (void)resizeRootView
{
    UIView* view = self.view;
    CGRect viewFrame = view.frame;
    UIWindow* window = UIApplication.sharedApplication.keyWindow;

    if (@available(iOS 11.0, *)) {
        UIEdgeInsets insets = window.safeAreaInsets;

        viewFrame.origin.x = insets.left;
        viewFrame.size.width = window.frame.size.width - insets.right - insets.left;
    }
    
    CGFloat keyboardLessHeight = window.frame.size.height - self.keyboardHeight;
    
    if ((keyboardLessHeight >= _minSize.height) && [NSUserDefaults.standardUserDefaults boolForKey:@"resizeGameWindowWhenTogglingKeyboard"])
    {
        viewFrame.size.height = keyboardLessHeight;
    }
    view.frame = viewFrame;
}

- (void)maybeToggleUI
{
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"overlayUIEnabled"])
    {
        if (!_gamepadViewController)
        {
            [self hideKeyboard];
            _gamepadViewController = [[UIStoryboard storyboardWithName:@"UIControls" bundle:nil] instantiateInitialViewController];
            [self.view addSubview:_gamepadViewController.view];
        }
    } else if (_gamepadViewController) {
        [self hideKeyboard];
        [_gamepadViewController.view removeFromSuperview];
        _gamepadViewController = nil;
    }
}


- (void)toggleScreenAutoresize {
    // since autoresize is the default behavior, we'll add our custom only when the setting is FALSE
#if !defined(DCSS_IOS)
    if (![NSUserDefaults.standardUserDefaults boolForKey:@"screenAutoresize"])
    {
        _uiAdaptor->on_screen_resize( [&]( ui_adaptor & ui ) {
            resize_term(get_option<int>( "TERMINAL_X" ), get_option<int>( "TERMINAL_Y" ));
        });
    } else {
        _uiAdaptor->on_screen_resize( [&]( ui_adaptor & ui ){});
    }
#endif
}

OnKeyboardHandler* _onKeyboardHandler;

- (void)viewWillTransitionToSize:(CGSize)size
       withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self maybeUpdateFrameTo:size];
}

- (void)maybeUpdateFrameTo:(CGSize)size {
    if (_gamepadViewController)
    {
        CGRect frame = _gamepadViewController.view.frame;
        frame.size = size;
        _gamepadViewController.view.frame = frame;
    }
}

GamePadViewController* _gamepadViewController;
@dynamic keyboardHeight;


#pragma mark - Gestures

-(void)addRecognizers
{
    self.view.gestureRecognizers = nil;
    
    UISwipeGestureRecognizer* showKeyboardGR;
    UISwipeGestureRecognizer* hideKeyboardGR;

    if ([NSUserDefaults.standardUserDefaults boolForKey:@"panningWith1Finger"])
    {
        showKeyboardGR = [KeyboardSwipeGestureRecognizer new];
        hideKeyboardGR = [KeyboardSwipeGestureRecognizer new];
    } else {
        showKeyboardGR = [UISwipeGestureRecognizer new];
        hideKeyboardGR = [UISwipeGestureRecognizer new];
    }
    showKeyboardGR.direction = UISwipeGestureRecognizerDirectionUp;
    showKeyboardGR.delaysTouchesBegan = YES;
    [showKeyboardGR addTarget:self action:@selector(showKeyboard)];
    
    hideKeyboardGR.direction = UISwipeGestureRecognizerDirectionDown;
    hideKeyboardGR.delaysTouchesBegan = YES;
    [hideKeyboardGR addTarget:self action:@selector(hideKeyboard)];
    
    UIPanGestureRecognizer* panViewGR = [UIPanGestureRecognizer new];
    [panViewGR addTarget:self action:@selector(panView:)];
    
    if ([NSUserDefaults.standardUserDefaults boolForKey:@"panningWith1Finger"])
    {
        [panViewGR requireGestureRecognizerToFail:showKeyboardGR];
        [panViewGR requireGestureRecognizerToFail:hideKeyboardGR];
    }
    else
        panViewGR.minimumNumberOfTouches = 2;

    UIPinchGestureRecognizer* zoomGR = [UIPinchGestureRecognizer new];
    [zoomGR addTarget:self action:@selector(zoom:)];
    _gestureRecognizerDelegate = [GestureRecognizerDelegate initWith:panViewGR and:zoomGR];
    zoomGR.delegate = _gestureRecognizerDelegate;
    
    UITapGestureRecognizer* centerViewGR = [UITapGestureRecognizer new];
    centerViewGR.numberOfTouchesRequired = 2;
    [centerViewGR addTarget:self action:@selector(centerView)];

    self.view.gestureRecognizers = @[showKeyboardGR, hideKeyboardGR, panViewGR, zoomGR, centerViewGR];
}

GestureRecognizerDelegate* _gestureRecognizerDelegate;

#pragma mark - Zoom handling

-(void)zoom:(UIPinchGestureRecognizer*)sender
{
    if ((sender.scale > _minScale) || (sender.scale < _maxScale))
    {
        bool in;
        int multiplier;
        if (sender.scale > 1)
        {
            in = true;
            multiplier = (sender.scale - 1) / _zoomingPrecision;
        }
        else
        {
            in = false;
            multiplier = (1 - sender.scale) / _zoomingPrecision;
        }
        sender.scale = 1;
        
        for (int i=0; i < multiplier; i++)
            zoom(in);
    }
}

const float _zoomingPrecision = 0.25;
const float _minScale = 1 + _zoomingPrecision;
const float _maxScale = 1 - _zoomingPrecision;



#pragma mark - Pan view

CGPoint lastPanningLocation;

-(void)panView:(UIPanGestureRecognizer*)sender
{
    if ((sender.state == UIGestureRecognizerStateChanged) || ( sender.state == UIGestureRecognizerStateEnded))
    {
        CGPoint currentLocation = [sender translationInView:sender.view];
        CGPoint movement = {.x=(currentLocation.x - lastPanningLocation.x), .y=(currentLocation.y - lastPanningLocation.y)};
        float xAbs = fabs(movement.x);
        float yAbs = fabs(movement.y);
        
        if ((xAbs > _panningPrecision) || (yAbs > _panningPrecision))
        {
            CGPoint newLocation = lastPanningLocation;
            PanViewHelperReturnType xRet = [self calculateMovement:movement.x plus:@"H" minus:@"L" previous:lastPanningLocation.x];
            NSString* xText = xRet.movementText;
            newLocation.x = xRet.newCoorinate;

            PanViewHelperReturnType yRet = [self calculateMovement:movement.y plus:@"K" minus:@"J" previous:lastPanningLocation.y];
            NSString* yText = yRet.movementText;
            newLocation.y = yRet.newCoorinate;

            NSString* longestString = (xText.length > yText.length) ? xText : yText;
            NSString* shortestString = (longestString == xText) ? yText : xText;
            NSInteger shortestStringLenght = shortestString.length;
            for (int i=0; i < longestString.length; i++)
            {
                [self typeSymbolOf:longestString atIndex:i];
                if (i < shortestStringLenght)
                    [self typeSymbolOf:shortestString atIndex:i];
            }
            lastPanningLocation = newLocation;
        }
    }
    if ((sender.state == UIGestureRecognizerStateCancelled) || ( sender.state == UIGestureRecognizerStateEnded))
    {
        lastPanningLocation = CGPointZero;
    }
}

-(PanViewHelperReturnType)calculateMovement:(CGFloat)movement plus:(NSString*)posSym minus:(NSString*)negSymbol previous:(CGFloat)previous
{
    NSString* movementText = @"";
    CGFloat newCoorinate = previous;
    float movementAbs = fabs(movement);
    if (movementAbs > _panningPrecision)
    {
        NSString* movementSym = ((movement > 0) != [NSUserDefaults.standardUserDefaults boolForKey:@"invertPan"]) ? posSym : negSymbol;
        int multiplier = movementAbs / _panningPrecision;
        movementText = [movementText stringByPaddingToLength:multiplier withString:movementSym startingAtIndex:0];
        newCoorinate = multiplier * _panningPrecision * (movement > 0 ? 1 : -1) + previous;
    }
    return (PanViewHelperReturnType){.movementText=movementText, .newCoorinate=newCoorinate};
}

-(void)typeSymbolOf:(NSString*)string atIndex:(int)index
{
    SDL_send_text_event([NSString stringWithFormat:@"%c", [string characterAtIndex:index]]);
}
const int _panningPrecision = 10;


# pragma mark - Cenver view

-(void)centerView
{
    SDL_send_text_event(@":");
}

@end
