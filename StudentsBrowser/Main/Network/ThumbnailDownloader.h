//
//  ThumbnailDownloader.h
//  StudentsBrowser
//
//  Created by Digital on 08/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Downloader.h"
#import "NetworkError.h"

@interface ThumbnailDownloader : Downloader

- (_Nonnull instancetype) init;
- (void) downloadImageAtURL:(NSURL* _Nonnull)url completion:(void(^_Nullable)(NSData* _Nullable imageData, NSError* _Nullable error))completion;

@end
