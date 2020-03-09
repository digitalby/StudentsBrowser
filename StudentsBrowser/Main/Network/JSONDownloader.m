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

- (void)validateJSONData:(NSData *)jsonData completion:(void (^)(NSArray * _Nullable, NSError * _Nullable))completion {
    NSError *dictionaryError;
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&dictionaryError];
    if(!responseDictionary) {
        NetworkError *error = [NetworkError errorWithErrorCode:NetworkErrorEmptyResponseDictionary];
        if (completion)
            completion(nil, error);
        return;
    }
    NSString* jsonError = [responseDictionary valueForKey:@"error"];
    if(jsonError) {
        NetworkError *error = [NetworkError errorWithErrorCode:NetworkErrorGotErrorResponse andExtraData:jsonError];
        if (completion)
            completion(nil, error);
        return;
    }
    NSArray *jsonArray = [responseDictionary valueForKeyPath:@"results"];
    if(!jsonArray) {
        NetworkError *error = [NetworkError errorWithErrorCode:NetworkErrorGotNilResult];
        if (completion)
            completion(nil, error);
        return;
    }
    if (completion)
        completion(jsonArray, nil);
}

- (void)downloadDataWithURL:(NSURL *)url completion:(void (^)(NSArray *, NSError *))completion {
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
        [NSUserDefaults.standardUserDefaults setObject:data forKey:@"people"];

        __block NSArray *jsonData;
        __block NSError *jsonError;
        [self validateJSONData:data completion:^(NSArray * _Nullable json, NSError * _Nullable error) {
            jsonData = json;
            jsonError = error;
        }];

        if (!completion)
            return;
        if (jsonError)
            completion(nil, jsonError);
        else if (jsonData)
            completion(jsonData, nil);
    }];
    [task resume];
}

- (void) downloadDataWithAmount:(NSUInteger)amount completion:(void (^)(NSArray* json, NSError* error))completion {
    NSString *urlString = kAPIURL;
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    if (!url) {
        NetworkError* error = [NetworkError errorWithErrorCode:NetworkErrorURLError andExtraData:urlString];
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
