//
//  NetworkError.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "NetworkError.h"

NSString* const kNetworkErrorDomain = @"me.digitalby.StudentsBrowser.NetworkError";

@interface NetworkError ()


@end

@implementation NetworkError

+ (instancetype) urlError {
    NetworkError* error = [[super alloc]initWithDomain:kNetworkErrorDomain code:NetworkErrorURLError userInfo:nil];
    return error;
}

+ (instancetype)invalidData {
    NetworkError* error = [[super alloc]initWithDomain:kNetworkErrorDomain code:NetworkErrorInvalidData userInfo:nil];
    return error;
}

@end
