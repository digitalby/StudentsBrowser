//
//  Location.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "Location.h"

@implementation Location

- (NSString * _Nonnull)addressLine {
    NSMutableString *string = [NSMutableString string];
    if (self.postcode)
        [string appendFormat:@"(%@)", self.postcode];
    if (self.streetName) {
        [string appendFormat:@" %@", self.streetName];
        if (self.streetNumber)
            [string appendFormat:@" %@", self.streetNumber];
    }
    return [string stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
}

- (NSString *)description
{
    NSString* coordinates = [NSString stringWithFormat: @"coordinates: %f,%f", self.coordinates.latitude, self.coordinates.longitude];
    NSString* city = [NSString stringWithFormat: @"city: %@", self.city];
    NSString* state = [NSString stringWithFormat: @"state: %@", self.state];
    NSString* country = [NSString stringWithFormat: @"country: %@", self.country];
    NSString* postcode = [NSString stringWithFormat: @"postcode: %@", self.postcode];
    NSString* streetName = [NSString stringWithFormat: @"streetName: %@", self.streetName];
    NSString* streetNumber = [NSString stringWithFormat: @"streetNumber: %@", self.streetNumber];
    NSString* timezoneDescription = [NSString stringWithFormat: @"timezoneDescription: %@", self.timezoneDescription];
    NSArray* array = @[
        coordinates,
        city,
        state,
        country,
        postcode,
        streetName,
        streetNumber,
        timezoneDescription
    ];

    NSString* formatString = [array componentsJoinedByString:[NSString stringWithFormat:@"\r    "]];
    return [NSString stringWithFormat:@"    {\r    %@\r    }", formatString];
}

@end
