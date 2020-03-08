//
//  Downloader.m
//  StudentsBrowser
//
//  Created by Digital on 08/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

- (instancetype) initWithConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    self.session = [NSURLSession sessionWithConfiguration: configuration];
    return self;
}

- (instancetype) init {
    NSURLSessionConfiguration* defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self = [self initWithConfiguration:defaultConfiguration];
    return self;
}

- (void) cancelOperations {
    [self.session getAllTasksWithCompletionHandler:^(NSArray<__kindof NSURLSessionTask *> * _Nonnull tasks) {
        for (NSURLSessionTask* task in tasks) {
            [task cancel];
        }
    }];
}

@end
