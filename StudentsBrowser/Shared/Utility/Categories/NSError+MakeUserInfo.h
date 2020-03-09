//
//  NSError+MakeUserInfo.h
//  StudentsBrowser
//
//  Created by Digital on 09/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (MakeUserInfo)

+ (NSDictionary * _Nonnull ) makeUserInfoWithDescription:(NSString * _Nullable)description failureReason:(NSString * _Nullable)failureReason recoverySuggestion:(NSString * _Nullable)recoverySuggestion;

@end

