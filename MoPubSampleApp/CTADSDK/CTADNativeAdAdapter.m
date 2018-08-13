//
//  MPCTADNativeAdAdapter.m
//  GoldMedal
//
//  Created by Mirinda on 17/7/10.
//  Copyright © 2017年 Mirinda. All rights reserved.
//

#import "CTADNativeAdAdapter.h"
#import "MPNativeAdConstants.h"

static NSString *const kCTADIconKey = @"icon";
static NSString *const kCTADImageKey = @"image";
static NSString *const kCTADSignImageKey = @"ADsignImage";
static NSString *const kCTADChoicesLinkKey = @"choices_link_url";

@implementation CTADNativeAdAdapter

@synthesize properties = _properties;
@synthesize defaultActionURL = _defaultActionURL;

- (instancetype)initWithCTNativeAd:(CTNativeAdModel*)CTNativeAd
{
    if ([super init])
    {
        self.nativeAd = CTNativeAd;
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        
        if (CTNativeAd.title)
        {
            properties[kAdTitleKey] = CTNativeAd.title;
        }
        
        if (CTNativeAd.desc)
        {
            properties[kAdTextKey] = CTNativeAd.desc;
        }
        
        if (CTNativeAd.icon)
        {
            properties[kAdIconImageKey] = CTNativeAd.icon;
        }
        
        if (CTNativeAd.image)
        {
            properties[kAdMainImageKey] = CTNativeAd.image;
        }
        
        if (CTNativeAd.iconImage)
        {
            properties[kCTADIconKey] = CTNativeAd.iconImage;
        }
        
        if (CTNativeAd.AdImage)
        {
            properties[kCTADImageKey] = CTNativeAd.AdImage;
        }
        
        if (CTNativeAd.button)
        {
            properties[kAdCTATextKey] = CTNativeAd.button;
        }
        
        if (CTNativeAd.star)
        {
            properties[kAdStarRatingKey] = [NSString stringWithFormat:@"%f", CTNativeAd.star];
        }
        
        if (CTNativeAd.ADsignImage)
        {
            properties[kCTADSignImageKey] = CTNativeAd.ADsignImage;
        }
        
        if (CTNativeAd.choices_link_url)
        {
            properties[kCTADChoicesLinkKey] = CTNativeAd.choices_link_url;
        }
        
        _properties = properties;

    }

    return self;
}


#pragma mark -delegate


#pragma mark - <MPNativeAdAdapter>

//- (UIView *)privacyInformationIconView
//{
    //return _adChoicesView;
//    return nil;
//}

- (BOOL)enableThirdPartyClickTracking
{
    return YES;
}


@end
