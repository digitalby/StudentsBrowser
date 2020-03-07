//
//  FullName.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "FullName.h"

@implementation FullName

- (instancetype)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName title:(NSString *)title {
    self.firstName = firstName;
    self.lastName = lastName;
    self.title = title;
    return self;
}

- (NSString *)makeFullName {
    return [
            NSString stringWithFormat:@"%@ %@ %@",
            self.title,
            self.firstName,
            self.lastName
            ];
}

- (NSString *)makeFirstAndLastName {
    return [
            NSString stringWithFormat:@"%@ %@",
            self.firstName,
            self.lastName
            ];
}

- (NSString *)makeTitleAndLastName {
    return [
            NSString stringWithFormat:@"%@ %@",
            self.title,
            self.lastName
            ];
}

- (NSString *) description {
    return [self makeFullName];
}

@end
