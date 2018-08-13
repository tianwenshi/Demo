//
//  CTADNativeRenderer.m
//  MoPubSampleApp
//
//  Created by Mirinda on 17/7/13.
//  Copyright © 2017年 MoPub. All rights reserved.
//

#import "CTADNativeRenderer.h"
#import "MPNativeAdRendererConfiguration.h"
#import "CTADNativeAdAdapter.h"
#import "MPNativeAdConstants.h"
#import "MPNativeAdAdapter.h"
#import "MPNativeAdError.h"
#import "MPNativeAdRendererConfiguration.h"
#import "MPNativeAdRendererImageHandler.h"
#import "MPNativeAdRendering.h"
#import "MPNativeAdRenderingImageLoader.h"
#import "MPNativeCache.h"
#import "MPNativeView.h"
#import "MPStaticNativeAdRendererSettings.h"
#import <CTSDK/CTSDK.h>

@interface CTADNativeRenderer()<MPNativeAdRendererImageHandlerDelegate,CTNativeAdDelegate>
@property(nonatomic, strong) UIView<MPNativeAdRendering> *adView;

/// MPGoogleAdMobNativeAdAdapter instance.
@property(nonatomic, strong) CTADNativeAdAdapter *adapter;

/// YES if adView is in view hierarchy.
@property(nonatomic, assign) BOOL adViewInViewHierarchy;

// MPNativeAdRendererImageHandler instance.
@property(nonatomic, strong) MPNativeAdRendererImageHandler *rendererImageHandler;

/// Class of renderingViewClass.
@property(nonatomic, strong) Class renderingViewClass;

/// GADNativeAppInstallAdView instance.
//@property(nonatomic, strong) GADNativeAppInstallAdView *appInstallAdView;
@end

@implementation CTADNativeRenderer
@synthesize viewSizeHandler;

+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:
(id<MPNativeAdRendererSettings>)rendererSettings {
    MPNativeAdRendererConfiguration *config = [[MPNativeAdRendererConfiguration alloc] init];
    config.rendererClass = [self class];
    config.rendererSettings = rendererSettings;
    config.supportedCustomEvents = @[@"CTADNativeCustomEvent"];
    
    return config;
}

/// Renderer settings are objects that allow you to expose configurable properties to the
/// application. MPGoogleAdMobNativeRenderer renderer will be initialized with these settings.
- (instancetype)initWithRendererSettings:(id<MPNativeAdRendererSettings>)rendererSettings {
    if (self = [super init]) {
        MPStaticNativeAdRendererSettings *settings =
        (MPStaticNativeAdRendererSettings *)rendererSettings;
        _renderingViewClass = settings.renderingViewClass;
        viewSizeHandler = [settings.viewSizeHandler copy];
        _rendererImageHandler = [MPNativeAdRendererImageHandler new];
        _rendererImageHandler.delegate = self;
    }
    
    return self;
}

/// Returns an ad view rendered using provided |adapter|. Sets an |error| if any error is
/// encountered.
- (UIView *)retrieveViewWithAdapter:(id<MPNativeAdAdapter>)adapter error:(NSError **)error {
    if (!adapter) {
        if (error) {
            *error = MPNativeAdNSErrorForRenderValueTypeError();
        }
        
        return nil;
    }
    
    self.adapter = (CTADNativeAdAdapter *)adapter;
    
    if ([self.renderingViewClass respondsToSelector:@selector(nibForAd)]) {
        self.adView = (UIView<MPNativeAdRendering> *)[[[self.renderingViewClass nibForAd] instantiateWithOwner:nil options:nil] firstObject];
    } else {
        self.adView = [[self.renderingViewClass alloc] init];
    }
    
    if ([self.adView  isKindOfClass:[CTNativeAd class]])
    {
        CTNativeAd* view =(CTNativeAd*)self.adView;
        view.adNativeModel = self.adapter.nativeAd;
        view.delegate = self;
    }
    
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    if ([self.adView respondsToSelector:@selector(nativeMainTextLabel)]) {
        self.adView.nativeMainTextLabel.text = [adapter.properties objectForKey:kAdTextKey];
    }
    
    if ([self.adView respondsToSelector:@selector(nativeTitleTextLabel)]) {
        self.adView.nativeTitleTextLabel.text = [adapter.properties objectForKey:kAdTitleKey];
    }
    
    if ([self.adView respondsToSelector:@selector(nativeCallToActionTextLabel)] && self.adView.nativeCallToActionTextLabel) {
        self.adView.nativeCallToActionTextLabel.text = [adapter.properties objectForKey:kAdCTATextKey];
    }
    
    if ([self.adView respondsToSelector:@selector(nativePrivacyInformationIconImageView)]) {
        UIImageView *imageView = self.adView.nativePrivacyInformationIconImageView;
        imageView.image = self.adapter.nativeAd.ADsignImage;
    }
    

    if ([self.adapter.delegate respondsToSelector:@selector(nativeAdWillLogImpression:)]) {
        [self.adapter.delegate nativeAdWillLogImpression:self.adapter];
    }
    
    CTNativeAd* view =(CTNativeAd*)self.adView;
    
    return self.adView;

}

- (BOOL)shouldLoadMediaView
{
    return [self.adapter respondsToSelector:@selector(mainMediaView)]
    && [self.adapter mainMediaView]
    && [self.adView respondsToSelector:@selector(nativeMainImageView)];
}

- (void)DAAIconTapped
{
    if ([self.adapter respondsToSelector:@selector(displayContentForDAAIconTap)]) {
        [self.adapter displayContentForDAAIconTap];
    }
}

- (void)adViewWillMoveToSuperview:(UIView *)superview
{
    self.adViewInViewHierarchy = (superview != nil);
    
    if (superview) {
        // We'll start asychronously loading the native ad images now.
        if ([self.adapter.properties objectForKey:kAdIconImageKey] && [self.adView respondsToSelector:@selector(nativeIconImageView)]) {
            [self.rendererImageHandler loadImageForURL:[NSURL URLWithString:[self.adapter.properties objectForKey:kAdIconImageKey]] intoImageView:self.adView.nativeIconImageView];
        }
        
        // Only handle the loading of the main image if the adapter doesn't already have a view for it.
        if (!([self.adapter respondsToSelector:@selector(mainMediaView)] && [self.adapter mainMediaView])) {
            if ([self.adapter.properties objectForKey:kAdMainImageKey] && [self.adView respondsToSelector:@selector(nativeMainImageView)]) {
                [self.rendererImageHandler loadImageForURL:[NSURL URLWithString:[self.adapter.properties objectForKey:kAdMainImageKey]] intoImageView:self.adView.nativeMainImageView];
            }
        }
        
        // Layout custom assets here as the custom assets may contain images that need to be loaded.
        if ([self.adView respondsToSelector:@selector(layoutCustomAssetsWithProperties:imageLoader:)]) {
            // Create a simplified image loader for the ad view to use.
            MPNativeAdRenderingImageLoader *imageLoader = [[MPNativeAdRenderingImageLoader alloc] initWithImageHandler:self.rendererImageHandler];
            [self.adView layoutCustomAssetsWithProperties:self.adapter.properties imageLoader:imageLoader];
        }
    }
}

#pragma mark - MPNativeAdRendererImageHandlerDelegate

- (BOOL)nativeAdViewInViewHierarchy {
    return self.adViewInViewHierarchy;
}

#pragma mark - CTNativdAdDelegate
-(void)CTNativeAdDidClick:(UIView *)nativeAd;{
    if ([self.adapter.delegate respondsToSelector:@selector(nativeAdDidClick:)]) {
        [self.adapter.delegate nativeAdDidClick:self.adapter];
    }
}

-(void)CTNativeAdDidIntoLandingPage:(UIView *)nativeAd{
}

-(void)CTNativeAdDidLeaveLandingPage:(UIView *)nativeAd{
    if ([self.adapter.delegate respondsToSelector:@selector(nativeAdDidDismissModalForAdapter:)]) {
        [self.adapter.delegate nativeAdDidDismissModalForAdapter:self.adapter];
    }
}
-(void)CTNativeAdWillLeaveApplication:(UIView *)nativeAd{
    if ([self.adapter.delegate respondsToSelector:@selector(nativeAdWillLeaveApplicationFromAdapter:)]) {
        [self.adapter.delegate nativeAdWillLeaveApplicationFromAdapter:self.adapter];
    }
}
-(void)CTNativeAdJumpfail:(UIView*)nativeAd
{
    
}
@end
