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
    return [NetworkError errorWithErrorCode:errorCode andExtraData:nil];
}

+ (instancetype)errorWithErrorCode:(NetworkErrorCode)errorCode andExtraData:(id)data {
    NSString *errorDescription = [NetworkError makeUserInfoDescriptionForErrorCode:errorCode];
    NSString *errorFailureReason = [NetworkError makeUserInfoFailureReasonForErrorCode:errorCode withExtraData:data];
    NSDictionary *userInfo = [NSError makeUserInfoWithDescription:errorDescription failureReason:errorFailureReason recoverySuggestion:nil];
    NetworkError* error = [[super alloc]initWithDomain:kNetworkErrorDomain code:errorCode userInfo:userInfo];
    return error;
}

+ (NSString *) makeUserInfoDescriptionForErrorCode:(NetworkErrorCode)errorCode {
    switch (errorCode) {
        case NetworkErrorURLError:
        case NetworkErrorRequestFailed:
        case NetworkErrorBadResponse:
            return @"Network request error";
        case NetworkErrorInvalidData:
        case NetworkErrorEmptyResponseDictionary:
        case NetworkErrorGotErrorResponse:
        case NetworkErrorGotNilResult:
            return @"Data validation error";
        case NetworkErrorParsingFailed:
            return @"Data parsing error";
    }
    return nil;
}

+ (NSString *) makeUserInfoFailureReasonForErrorCode:(NetworkErrorCode)errorCode withExtraData:(id)data {
    switch (errorCode) {
        case NetworkErrorURLError: {
            NSString *failureReason = @"Invalid URL ";
            NSString *urlString = (NSString *)data;
            if (urlString)
                failureReason = [failureReason stringByAppendingString:urlString];
            return failureReason;
        }
        case NetworkErrorRequestFailed: {
            NSString *failureReason = @"The network request has failed ";
            NSError *underlyingError = (NSError *)data;
            if (underlyingError)
                failureReason = [failureReason stringByAppendingFormat:@"with underlying error: %@", underlyingError.localizedDescription];
            return failureReason;
        }
        case NetworkErrorBadResponse: {
            NSString *failureReason = @"Got an HTTP error ";
            NSNumber *responseCode = (NSNumber *)data;
            if (responseCode)
                failureReason = [failureReason stringByAppendingFormat:@"with code %@", responseCode];
            return failureReason;
        }
        case NetworkErrorInvalidData:
            return @"The data is unreadable or corrupted";
        case NetworkErrorEmptyResponseDictionary:
            return @"The server responded with empty data";
        case NetworkErrorGotErrorResponse: {
            NSString *failureReason = @"The server responded with an error ";
            NSString *jsonError = (NSString *)data;
            if (jsonError)
                failureReason = [failureReason stringByAppendingFormat:@"(%@)", jsonError];
            return failureReason;
        }
        case NetworkErrorGotNilResult:
            return @"The server responded with invalid or corrupted results";
        case NetworkErrorParsingFailed:
            return @"The data couldn't be converted to a human readable format.";
    }
    return nil;
}

@end
