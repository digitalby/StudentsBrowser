//
//  Login.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "Login.h"

@implementation Login

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
    self.username = username;
    self.password = password;
    return self;
}

@end
