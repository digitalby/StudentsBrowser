//
//  JSONDownloader.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "JSONDownloader.h"

NSString* const kAPIURL = @"https://randomuser.me/api";

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

- (void) downloadDataWithCompletion:(void (^)(NSArray* json, NSError* error))completion {
    NSURLSession *session = self.session;
    NSURL *url = [[NSURL alloc] initWithString:kAPIURL];
    if (!url) {
        NetworkError* error = [NetworkError urlError];
        completion(nil, error);
        return;
    }
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        if (!data) {
            NetworkError *error = [NetworkError invalidData];
            completion(nil, error);
            return;
        }
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSArray *jsonData = [responseDictionary valueForKeyPath:@"results"];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(jsonData, error);
        });
    }];
    [task resume];
}

@end
