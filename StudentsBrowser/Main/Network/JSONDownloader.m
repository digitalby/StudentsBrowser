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

- (instancetype) init {
    self = [super init];
    return self;
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
            NetworkError* error = [NetworkError errorWithErrorCode:NetworkErrorGotNilResult];
            if (completion)
                completion(nil, error);
            return;
        }

        if (completion)
            completion(jsonData, nil);
    }];
    [task resume];
}

- (void) downloadDataWithAmount:(NSUInteger)amount completion:(void (^)(NSArray* json, NSError* error))completion {
    NSURL *url = [[NSURL alloc] initWithString:kAPIURL];
    if (!url) {
        NetworkError* error = [NetworkError errorWithErrorCode:NetworkErrorURLError];
        if (completion)
            completion(nil, error);
        return;
    }
    NSString* amountQuery = [NSString stringWithFormat:@"results=%tu", amount];
    url = [url appendingQueryString:amountQuery];
    [self downloadDataWithURL:url completion:completion];
}

- (void) downloadDataWithCompletion:(void (^)(NSArray* json, NSError* error))completion {
    [self downloadDataWithAmount:1 completion:completion];
}

@end
