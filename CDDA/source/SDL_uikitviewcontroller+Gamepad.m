#import <__wctype.h>
//
// Created by Аполлов Юрий Андреевич on 17.01.2021.
// Copyright (c) 2021 Аполлов Юрий Андреевич. All rights reserved.
//

@import CoreGraphics;

#import "SDL_char_utils.h"

#import "SDL_uikitviewcontroller+Gamepad.h"
#import "GamePadViewController.h"


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

- (void)viewDidAppear:(BOOL)animated {
    for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification, UIApplicationDidBecomeActiveNotification, UIApplicationWillResignActiveNotification])
        [self registerNotification:notification forSelector:@selector(resizeRootView)];
    [NSUserDefaults.standardUserDefaults addObserver:self forKeyPath:@"overlayUIEnabled" options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:nil];

    [self resizeRootView];
    [self addRecognizers];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqual: @"overlayUIEnabled"])
        [self maybeToggleUI];
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

            _onKeyboardHandler = [OnKeyboardHandler initWithController:self];
            for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
                [[NSNotificationCenter defaultCenter] addObserver:_onKeyboardHandler selector:@selector(onKeyboard) name:notification object:nil];
            }
        }
    } else if (_gamepadViewController) {
        [self hideKeyboard];
        [_gamepadViewController.view removeFromSuperview];
        _gamepadViewController = nil;
        for (NSNotificationName notification in @[UIKeyboardWillShowNotification, UIKeyboardWillHideNotification]) {
            [[NSNotificationCenter defaultCenter] removeObserver:_onKeyboardHandler name:notification object:nil];
        }
        _onKeyboardHandler = nil;
    }
}

OnKeyboardHandler* _onKeyboardHandler;

- (void)registerNotification:(NSNotificationName)notification forSelector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:selector name:notification object:nil];
}

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
    KeyboardSwipeGestureRecognizer* showKeyboardGR = [KeyboardSwipeGestureRecognizer new];
    showKeyboardGR.direction = UISwipeGestureRecognizerDirectionUp;
    showKeyboardGR.delaysTouchesBegan = YES;
    [showKeyboardGR addTarget:self action:@selector(showKeyboard)];
    
    KeyboardSwipeGestureRecognizer* hideKeyboardGR = [KeyboardSwipeGestureRecognizer new];
    hideKeyboardGR.direction = UISwipeGestureRecognizerDirectionDown;
    hideKeyboardGR.delaysTouchesBegan = YES;
    [hideKeyboardGR addTarget:self action:@selector(hideKeyboard)];
    
    UIPanGestureRecognizer* panViewGR = [UIPanGestureRecognizer new];
    [panViewGR addTarget:self action:@selector(panView:)];
    [panViewGR requireGestureRecognizerToFail:showKeyboardGR];
    [panViewGR requireGestureRecognizerToFail:hideKeyboardGR];

    UIPinchGestureRecognizer* zoomGR = [UIPinchGestureRecognizer new];
    [zoomGR addTarget:self action:@selector(zoom:)];
    _gestureRecognizerDelegate = [GestureRecognizerDelegate initWith:panViewGR and:zoomGR];
    zoomGR.delegate = _gestureRecognizerDelegate;
    
    UITapGestureRecognizer* centerViewGR = [UITapGestureRecognizer new];
    centerViewGR.numberOfTouchesRequired = 2;
    [centerViewGR addTarget:self action:@selector(centerView)];

    for (UIGestureRecognizer* recognizer in @[showKeyboardGR, hideKeyboardGR, panViewGR, zoomGR, centerViewGR])
        [self.view addGestureRecognizer:recognizer];
}

GestureRecognizerDelegate* _gestureRecognizerDelegate;


#pragma mark - Zoom handling

-(void)zoom:(UIPinchGestureRecognizer*)sender
{
    if ((sender.scale > _minScale) || (sender.scale < _maxScale))
    {
        NSString* text;
        int multiplier;
        if (sender.scale > 1)
        {
            text = @"z";
            multiplier = (sender.scale - 1) / _zoomingPrecision;
        }
        else
        {
            text = @"Z";
            multiplier = (1 - sender.scale) / _zoomingPrecision;
        }
        sender.scale = 1;
        
        for (int i=0; i < multiplier; i++)
            SDL_send_text_event(text);
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
