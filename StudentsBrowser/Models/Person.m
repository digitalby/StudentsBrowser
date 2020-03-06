//
//  Person.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSUInteger)age {
    if (!self.dateOfBirth)
        return NSUIntegerMax;
    NSTimeInterval timeInterval = self.dateOfBirth.timeIntervalSinceNow;
    NSDate *today = [NSDate now];
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSinceNow:timeInterval];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *components = [calendar components:unit fromDate:date toDate:today options:kNilOptions];
    NSInteger years = [components year];
    return years;
}

- (NSString *) description {
    NSString* cellPhoneNumber = [NSString stringWithFormat:@"cellPhoneNumber: %@", self.cellPhoneNumber];
    NSString* phoneNumber = [NSString stringWithFormat:@"phoneNumber: %@", self.phoneNumber];
    NSString* dateOfBirth = [NSString stringWithFormat:@"dateOfBirth: %@", self.dateOfBirth];
    NSString* age = [NSString stringWithFormat:@"age: %tu", self.age];
    NSString* email = [NSString stringWithFormat:@"email: %@", self.email];
    NSString* gender = [NSString stringWithFormat:@"gender: %zd", self.gender];
    NSString* fullName = [NSString stringWithFormat:@"fullName: %@", self.fullName];
    NSString* nationality = [NSString stringWithFormat:@"nationality: %@", self.nationality];
    NSString* login = [NSString stringWithFormat:@"login: %@", self.login];
    NSString* picture = [NSString stringWithFormat:@"picture: %@", self.picture];
    NSString* location = [NSString stringWithFormat:@"location: %@", self.location];
    NSArray* array = @[
        cellPhoneNumber,
        phoneNumber,
        dateOfBirth,
        age,
        email,
        gender,
        fullName,
        nationality,
        login,
        picture,
        location
    ];
    NSString* formatString = [array componentsJoinedByString:[NSString stringWithFormat:@"\r    "]];
    return [NSString stringWithFormat:@"    {\r    %@\r    }", formatString];
}

@end
