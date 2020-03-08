//
//  Downloader.h
//  StudentsBrowser
//
//  Created by Digital on 08/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Downloader : NSObject

@property (nonatomic) NSURLSession* _Nonnull session;

- (instancetype) init;
- (instancetype) initWithConfiguration:(NSURLSessionConfiguration* _Nonnull)configuration;
- (void) cancelOperations;

@end

NS_ASSUME_NONNULL_END
