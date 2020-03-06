//
//  NetworkError.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkError : NSError

typedef NS_ENUM(NSInteger, NetworkErrorCode) {
    NetworkErrorURLError,
    NetworkErrorInvalidData
};

+ (instancetype) urlError;
+ (instancetype) invalidData;

@end

NS_ASSUME_NONNULL_END
