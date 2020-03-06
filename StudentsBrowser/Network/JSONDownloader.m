//
//  JSONDownloader.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "JSONDownloader.h"

NSString* const kAPIURL = @"https://randomuser.me/api/";

@interface JSONDownloader ()

@end

@implementation JSONDownloader

- (instancetype) initWithConfiguration:(NSURLSessionConfiguration *)configuration {
    self.session = [NSURLSession sessionWithConfiguration: configuration];
    return self;
}

- (instancetype) init {
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [[JSONDownloader alloc] initWithConfiguration:defaultConfiguration];
}

- (void)downloadDataWithURL:(NSURL *)url completion:(void (^)(NSArray *, NSError *))completion {
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
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(!responseDictionary) {
            NetworkError *error = [NetworkError errorWithErrorCode:NetworkErrorEmptyResponseDictionary];
            if (completion)
                completion(nil, error);
            return;
        }
        NSString* jsonError = [responseDictionary valueForKey:@"error"];
        if(jsonError) {
            NetworkError* error = [NetworkError errorWithErrorCode:NetworkErrorGotErrorResponse];
            if (completion)
                completion(nil, error);
            return;
        }
        NSArray *jsonData = [responseDictionary valueForKeyPath:@"results"];
        if(!jsonData) {
            NetworkError* error = [NetworkError errorWithErrorCode:NetworkErrorGotNilResults];
            if (completion)
                completion(nil, error);
            return;
        }

        if (completion)
            completion(jsonData, nil);
    }];
    [task resume];
}

- (void) downloadDataWithCompletion:(void (^)(NSArray* json, NSError* error))completion {
    NSURL *url = [[NSURL alloc] initWithString:kAPIURL];
    if (!url) {
        NetworkError* error = [NetworkError errorWithErrorCode:NetworkErrorURLError];
        if (completion)
            completion(nil, error);
        return;
    }
    [self downloadDataWithURL:url completion:completion];
}

@end
