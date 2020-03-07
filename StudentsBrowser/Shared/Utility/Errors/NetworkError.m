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

+ (instancetype) errorWithErrorCode:(NetworkErrorCode)errorCode {
    NetworkError* error = [[super alloc]initWithDomain:kNetworkErrorDomain code:errorCode userInfo:nil];
    return error;
}

@end
