//
//  CTADInterstitialCustomEvent.m
//  MoPubSampleApp
//
//  Created by Mirinda on 17/7/10.
//  Copyright © 2017年 MoPub. All rights reserved.
//

#import "CTADInterstitialCustomEvent.h"
#import <CTSDK/CTSDK.h>
#import <CTSDK/CTADMRAIDView.h>

@interface CTADInterstitialCustomEvent()<CTAdViewDelegate>

@end

@implementation CTADInterstitialCustomEvent

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    NSString *slotid = [info objectForKey:@"slotid"];
    CTService* manager = [CTService shareManager];
    [manager loadRequestGetCTSDKConfigBySlot_id:slotid];
    [manager preloadMRAIDInterstitialAdWithSlotId:slotid delegate:self isTest:NO];
}


- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    CTService* manager = [CTService shareManager];
    [manager mraidInterstitialShow];
    
    if ([self.delegate respondsToSelector:@selector(trackImpression)])
    {
        [self.delegate trackImpression];
    }
}

- (void)dealloc
{
    
}

#pragma mark CTAdViewDelegate methods
//banner ad
- (void)CTAdViewDidRecieveInterstitialAd {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)])
    {
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
    }
    
}

//error while request ads.
- (void)CTAdView:(CTADMRAIDView*)adView didFailToReceiveAdWithError:(NSError*)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)])
    {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

//jump to safari or internal webview
- (BOOL)CTAdView:(CTADMRAIDView*)adView shouldOpenURL:(NSURL*)url {
    if ([self.delegate respondsToSelector:@selector(trackClick)])
    {
        [self.delegate trackClick];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)])
    {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
    return YES;
}


//will leave application
- (void)CTAdViewWillLeaveApplication:(CTADMRAIDView*)adView {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillLeaveApplication:)])
    {
        [self.delegate interstitialCustomEventWillLeaveApplication:self];
    }
}

//did click close button
- (void)CTAdViewCloseButtonPressed:(CTADMRAIDView*)adView {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)])
    {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)])
    {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
    
}
@end
