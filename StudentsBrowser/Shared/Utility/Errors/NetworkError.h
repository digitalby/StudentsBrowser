//
//  NetworkError.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+MakeUserInfo.h"

@interface NetworkError : NSError

typedef NS_ENUM(NSInteger, NetworkErrorCode) {
    NetworkErrorURLError,
    NetworkErrorRequestFailed,
    NetworkErrorBadResponse,
    NetworkErrorInvalidData,
    NetworkErrorEmptyResponseDictionary,
    NetworkErrorGotErrorResponse,
    NetworkErrorGotNilResult,
    NetworkErrorParsingFailed
};

+ (instancetype _Nonnull) errorWithErrorCode:(NetworkErrorCode)errorCode;
+ (instancetype _Nonnull) errorWithErrorCode:(NetworkErrorCode)errorCode andExtraData:(id _Nullable)data;

@end
