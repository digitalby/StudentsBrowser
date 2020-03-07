//
//  NSURL+Query.m
//  StudentsBrowser
//
//  Created by Digital on 07/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "NSURL+Query.h"

@implementation NSURL (Query)

- (NSURL *)appendingQueryString:(NSString *)queryString {
    if (![queryString length]) {
        return self;
    }

    NSString *URLString = [[NSString alloc] initWithFormat:@"%@%@%@", [self absoluteString],
                           [self query] ? @"&" : @"?", queryString];
    NSURL *url = [NSURL URLWithString:URLString];
    return url;
}

@end
