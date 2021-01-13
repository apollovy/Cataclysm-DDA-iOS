//
//  SDL_uikitviewcontroller+GoogleAds.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
@import GoogleMobileAds;

#import "GamePadViewController+GoogleAds.h"

@implementation GamePadViewController (GoogleAds)


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
                                      initWithAdSize:kGADAdSizeBanner];
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

@end
