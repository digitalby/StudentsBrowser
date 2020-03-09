//
//  NSError+MakeUserInfo.m
//  StudentsBrowser
//
//  Created by Digital on 09/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "NSError+MakeUserInfo.h"

@implementation NSError (MakeUserInfo)

+ (NSDictionary *)makeUserInfoWithDescription:(NSString *)description failureReason:(NSString *)failureReason recoverySuggestion:(NSString *)recoverySuggestion {
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    if(description)
        [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
    else
        [userInfo setObject:[NSNull null] forKey:NSLocalizedDescriptionKey];
    if(failureReason)
        [userInfo setObject:failureReason forKey:NSLocalizedFailureReasonErrorKey];
    else
        [userInfo setObject:[NSNull null] forKey:NSLocalizedFailureReasonErrorKey];
    if(recoverySuggestion)
        [userInfo setObject:recoverySuggestion forKey:NSLocalizedRecoverySuggestionErrorKey];
    else
        [userInfo setObject:[NSNull null] forKey:NSLocalizedRecoverySuggestionErrorKey];
    return userInfo;
}

@end
