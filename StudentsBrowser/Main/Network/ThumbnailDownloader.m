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
            NetworkError *error = [NetworkError errorWithErrorCode:NetworkErrorRequestFailed];
            if (completion)
                completion(nil, error);
            return;
        }
        if (httpResponse.statusCode != 200) {
            NetworkError *error = [NetworkError errorWithErrorCode:NetworkErrorBadResponse];
            if (completion)
                completion(nil, error);
            return;
        }
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        if (!data) {
            NetworkError *error = [NetworkError errorWithErrorCode:NetworkErrorInvalidData];
            if (completion)
                completion(nil, error);
            return;
        }
//        UIImage* image = [[UIImage alloc]initWithData:data];
//        if (!image) {
//            NetworkError* error = [NetworkError errorWithErrorCode:NetworkErrorGotNilResult];
//            if (completion)
//                completion(nil, error);
//            return;
//        }

        if (completion)
            completion(data, nil);
    }];
    [task resume];
}

@end
