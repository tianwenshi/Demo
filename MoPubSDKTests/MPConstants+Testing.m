//
//  MPConstants+Testing.m
//  MoPubSDK
//
//  Copyright © 2017 MoPub. All rights reserved.
//

#import "MPConstants+Testing.h"

static NSTimeInterval const kAdsExpirationTimeIntervalForTesting = 1; // 1 second

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
@implementation MPConstants (Testing)

+ (NSTimeInterval)adsExpirationInterval {
    return kAdsExpirationTimeIntervalForTesting;
}

@end
#pragma clang diagnostic pop
