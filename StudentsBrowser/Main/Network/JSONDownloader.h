//
//  JSONDownloader.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkError.h"
#import "NSURL+Query.h"
#import "Downloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSONDownloader : Downloader

- (instancetype) init;
- (void) downloadDataWithURL:(NSURL*)url completion:(void (^_Nullable)(NSArray* _Nullable json, NSError* _Nullable error))completion;
- (void) downloadDataWithCompletion:(void (^_Nullable)(NSArray* _Nullable json, NSError* _Nullable error))completion;
- (void) downloadDataWithAmount:(NSUInteger)amount completion:(void (^_Nullable)(NSArray* _Nullable json, NSError* _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
