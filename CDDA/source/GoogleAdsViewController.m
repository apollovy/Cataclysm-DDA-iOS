//
//  GoogleAdsViewController.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
@import GoogleMobileAds;

#import "GoogleAdsViewController.h"

@implementation GoogleAdsViewController

+(GADAdSize)getBannerSize{
    return kGADAdSizeLeaderboard;
}

- (void)viewDidAppear:(BOOL)animated {
    // only add banner once
    if (!self.bannerView) {
        @try {
            [self addBannerViewToView];
        } @catch (NSException* exception) {
            self.bannerView = nil;
            NSLog(@"CDDA-iOS::Adding banner resulted in error::%@",
                    exception.reason);
        }
    }
}

- (void)addBannerViewToView
{
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc]
                                      initWithAdSize:[GoogleAdsViewController
                                      getBannerSize]];
    GADBannerView* bannerView = self.bannerView;
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.topLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]
     ];
    self.bannerView.adUnitID = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"GATopBannerAdUnitId"];
    self.bannerView.rootViewController = self;
    GADRequest* request = [GADRequest request];
    [self.bannerView loadRequest:request];
    self.bannerView.delegate = self;
}

- (void) toggleBannerView {
    [UIView transitionWithView:self.bannerView
            duration:0.4
            options:UIViewAnimationOptionTransitionCrossDissolve
            animations:^{
                self.bannerView.hidden = !self.bannerView.hidden;
            }
            completion:NULL];
}

# pragma: Google ad banner view

GADBannerView* _bannerView;

-(GADBannerView*)bannerView
{
    return _bannerView;
}

-(void)setBannerView:(GADBannerView*)view
{
    _bannerView = view;
}

# pragma: GADBannerViewDelegate

-(void) adViewWillLeaveApplication:(GADBannerView*) bannerView
{
    [self toggleBannerView];
    int delay = [[[NSBundle mainBundle]
                            objectForInfoDictionaryKey:@"GATopBannerHideTime"]
                            intValue];
    [self performSelector:@selector(toggleBannerView) withObject:self
                                                      afterDelay:delay];
}

- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    // Gets the domain from which the error came.
    NSString *errorDomain = error.domain;
    // Gets the error code. See
    // https://developers.google.com/admob/ios/api/reference/Enums/GADErrorCode
    // for a list of possible codes.
    long errorCode = error.code;
    // Gets an error message.
    // For example "Account not approved yet". See
    // https://support.google.com/admob/answer/9905175 for explanations of
    // common errors.
    NSString *errorMessage = error.localizedDescription;
    // Gets the underlyingError, if available.
    NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
    NSLog(@"Received error with domain: %@, code: %ld, message: %@, "
          @"underLyingError: %@",
            errorDomain, errorCode, errorMessage,
            underlyingError.localizedDescription);
}

@end
