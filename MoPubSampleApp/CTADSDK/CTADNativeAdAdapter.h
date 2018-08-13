//
//  MPCTADNativeAdAdapter.h
//  GoldMedal
//
//  Created by Mirinda on 17/7/10.
//  Copyright © 2017年 Mirinda. All rights reserved.
//

#if __has_include(<MoPub / MoPub.h>)
#import <MoPub/MoPub.h>
#else
#import "MPNativeAdAdapter.h"
#endif

#import <Foundation/Foundation.h>
#import <CTSDK/CTSDK.h>

@interface CTADNativeAdAdapter : NSObject<MPNativeAdAdapter,CTNativeAdDelegate>

@property(nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;
@property(nonatomic, strong) CTNativeAdModel *nativeAd;
- (instancetype)initWithCTNativeAd:(CTNativeAdModel*)CTNativeAd;

@end
