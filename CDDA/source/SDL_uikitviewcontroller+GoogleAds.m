//
//  SDL_uikitviewcontroller+GoogleAds.m
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 05/01/2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//
#import "objc/runtime.h"

@import GoogleMobileAds;

#import "SDL_uikitviewcontroller+GoogleAds.h"

@implementation SDL_uikitviewcontroller (GoogleAds)


- (void)googleAdsModifiedSetView:(UIView*)view
{
    [self googleAdsModifiedSetView:view];
    
    // In this case, we instantiate the banner with desired ad size.
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    
    [self addBannerViewToView:self.bannerView];
}

- (void)addBannerViewToView:(UIView *)bannerView {
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
    
    // FIXME: replace with more sane approach
    self.bannerView.adUnitID = @"ca-app-pub-9615054841988249/9046413488";
    self.bannerView.rootViewController = self;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[ kGADSimulatorID ];
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

+(void)load
{
    Method originalSetView = class_getInstanceMethod(self, @selector(setView:));
    Method modifiedSetView = class_getInstanceMethod(self, @selector(googleAdsModifiedSetView:));
    method_exchangeImplementations(originalSetView, modifiedSetView);
}

@end
