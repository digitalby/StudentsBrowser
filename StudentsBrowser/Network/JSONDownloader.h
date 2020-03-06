//
//  JSONDownloader.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkError.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSONDownloader : NSObject

@property (nonatomic) NSURLSession* _Nonnull session;

- (instancetype) init;
- (instancetype) initWithConfiguration:(NSURLSessionConfiguration* _Nonnull)configuration;
- (void) downloadDataWithCompletion:(void (^_Nullable)(NSArray* _Nullable json, NSError* _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
