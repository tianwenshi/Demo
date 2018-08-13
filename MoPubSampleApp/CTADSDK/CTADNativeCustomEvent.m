//
//  MPCTADNativeCustomEvent.m
//  GoldMedal
//
//  Created by Mirinda on 17/7/10.
//  Copyright © 2017年 Mirinda. All rights reserved.
//

#import "CTADNativeCustomEvent.h"
#import "CTADNativeAdAdapter.h"
#import <CTSDK/CTSDK.h>
#import "MPNativeAd.h"
#import "MPLogging.h"

@implementation CTADNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    NSString *slotid = [info objectForKey:@"slotid"];
    CTService *service = [CTService shareManager];
    [service loadRequestGetCTSDKConfigBySlot_id:slotid];

    [service getNativeADswithSlotId:slotid delegate:self imageWidthHightRate:CTImageWHRateOnePointNineToOne isTest:NO success:^(CTNativeAdModel *nativeModel)
     {
         CTADNativeAdAdapter *adAdapter = [[CTADNativeAdAdapter alloc] initWithCTNativeAd:nativeModel];
         MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adAdapter];
         
         [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        
    } failure:^(NSError *error) {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:error];
    }];
}
@end
