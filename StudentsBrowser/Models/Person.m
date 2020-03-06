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

@end
