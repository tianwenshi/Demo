//
//  CTADNativeRenderer.h
//  MoPubSampleApp
//
//  Created by Mirinda on 17/7/13.
//  Copyright © 2017年 MoPub. All rights reserved.
//

#if __has_include(<MoPub / MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPNativeAdRenderer.h"
#import "MPNativeAdRendererSettings.h"
#endif

@class MPNativeAdRendererConfiguration;
@class MPStaticNativeAdRendererSettings;

@interface CTADNativeRenderer : NSObject<MPNativeAdRendererSettings>

/// The viewSizeHandler is used to allow the app to configure its native ad view size.
@property(nonatomic, readwrite, copy) MPNativeViewSizeHandler viewSizeHandler;

/// Constructs and returns an MPNativeAdRendererConfiguration object specific for the
/// CTADNativeRenderer. You must set all the properties on the configuration object.
/// @param rendererSettings Application defined settings.
/// @return A configuration object for CTADNativeRenderer.
+ (MPNativeAdRendererConfiguration *)rendererConfigurationWithRendererSettings:
(id<MPNativeAdRendererSettings>)rendererSettings;
@end

//@interface CTAdNativeView :CTNativeAd<MPNativeAdRendering>
//@end
