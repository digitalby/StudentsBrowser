//
//  ThumbnailDownloader.m
//  StudentsBrowser
//
//  Created by Digital on 08/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "ThumbnailDownloader.h"

@implementation ThumbnailDownloader

- (instancetype) init {
    self = [super init];
    return self;
}

- (void)downloadImageAtURL:(NSURL *)url completion:(void (^)(NSData * _Nullable, NSError * _Nullable))completion {
    NSURLSession *session = self.session;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        if (!httpResponse) {
            NetworkError *networkError = [NetworkError errorWithErrorCode:NetworkErrorRequestFailed andExtraData:error];
            if (completion)
                completion(nil, networkError);
            return;
        }
        NSInteger statusCode = httpResponse.statusCode;
        if (statusCode != 200) {
            NetworkError *networkError = [NetworkError errorWithErrorCode:NetworkErrorBadResponse andExtraData:@(statusCode)];
            if (completion)
                completion(nil, networkError);
            return;
        }
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        if (!data) {
            NetworkError *networkError = [NetworkError errorWithErrorCode:NetworkErrorInvalidData];
            if (completion)
                completion(nil, networkError);
            return;
        }
        if (completion)
            completion(data, nil);
    }];
    [task resume];
}

@end
