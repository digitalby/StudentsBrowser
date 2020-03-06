//
//  Login.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Login : NSObject

@property(nonatomic) NSString* username;
@property(nonatomic) NSString* password;

- (instancetype)initWithUsername:(NSString*)username password:(NSString*)password;

@end

NS_ASSUME_NONNULL_END
