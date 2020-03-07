//
//  NSURL+Query.h
//  StudentsBrowser
//
//  Created by Digital on 07/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Query)

- (NSURL *)appendingQueryString:(NSString *)queryString;

@end

NS_ASSUME_NONNULL_END
