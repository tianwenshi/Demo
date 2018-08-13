//
//  CTADBannerCustomEvent.m
//  MoPubSampleApp
//
//  Created by Mirinda on 17/7/7.
//  Copyright © 2017年 MoPub. All rights reserved.
//

#import "CTADBannerCustomEvent.h"
#import <CTSDK/CTSDK.h>
#import <CTSDK/CTADMRAIDView.h>

@interface CTADBannerCustomEvent()<CTAdViewDelegate>
@property (nonatomic,strong)CTADMRAIDView* mraidBanner;
@end

@implementation CTADBannerCustomEvent


- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{
    NSString *slotid = [info objectForKey:@"slotid"];
    CTService* manager = [CTService shareManager];
    [manager loadRequestGetCTSDKConfigBySlot_id:slotid];
    CTADBannerSize bannerSize;
    if (size.height > 25 && size.height <= 75)
    {
        bannerSize = CTADBannerSizeW320H50;
    }
    else if (size.height > 75 && size.height <= 175)
    {
        bannerSize = CTADBannerSizeW320H100;
    }
    else if (size.height > 175 && size.height < 300)
    {
        bannerSize = CTADBannerSizeW300H250;
    }
    else
    {
        NSError* error = [NSError errorWithDomain:@"No ad for input banner size." code:99999 userInfo:nil];
        if ([self.delegate respondsToSelector:@selector(bannerCustomEvent:didFailToLoadAdWithError:)])
        {
            [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        }
        return;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    [manager getMRAIDBannerAdWithSlot:slotid delegate:self adSize:bannerSize container:view isTest:YES];
}

- (void)dealloc
{
    if (self.mraidBanner)
    {
        [self.mraidBanner removeFromSuperview];
    }
}

#pragma mark CTAdViewDelegate methods

//banner ad
- (void)CTAdViewDidRecieveBannerAd:(CTADMRAIDView*)adView {
    self.mraidBanner = adView;
    if ([self.delegate respondsToSelector:@selector(bannerCustomEvent:didLoadAd:)])
    {
        [self.delegate bannerCustomEvent:self didLoadAd:adView];
    }

    if ([self.delegate respondsToSelector:@selector(trackImpression)])
    {
        [self.delegate trackImpression];
    }
    
}

//error while request ads.
- (void)CTAdView:(CTADMRAIDView*)adView didFailToReceiveAdWithError:(NSError*)error {
    
    if ([self.delegate respondsToSelector:@selector(bannerCustomEvent:didFailToLoadAdWithError:)])
    {
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    }
}

//jump to safari or internal webview
- (BOOL)CTAdView:(CTADMRAIDView*)adView shouldOpenURL:(NSURL*)url {
    if ([self.delegate respondsToSelector:@selector(trackClick)])
    {
        [self.delegate trackClick];
    }
    return YES;
}

//will leave application
- (void)CTAdViewWillLeaveApplication:(CTADMRAIDView*)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)])
    {
        [self.delegate bannerCustomEventWillLeaveApplication:self];
    }
}

@end
