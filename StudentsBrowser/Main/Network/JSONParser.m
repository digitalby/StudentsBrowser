//
//  JSONParser.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

- (NSArray*)getPeopleFromJSONArray:(NSArray *)jsonArray {
    NSMutableArray * arrayOfPeople = [[NSMutableArray alloc]init];

    for (NSDictionary *personDictionary in jsonArray) {
        Person* person = [[Person alloc]init];

        person.cellPhoneNumber = [personDictionary valueForKey:@"cell"];
        person.phoneNumber = [personDictionary valueForKey:@"phone"];
        person.nationality = [personDictionary valueForKey:@"nat"];
        person.email = [personDictionary valueForKey:@"email"];

        NSDate *dateOfBirth;
        NSDictionary *dateOfBirthDictionary = [personDictionary valueForKey:@"dob"];
        if (dateOfBirthDictionary) {
            NSString *dateOfBirthString = [dateOfBirthDictionary valueForKey:@"date"];
            NSISO8601DateFormatter *formatter = [[NSISO8601DateFormatter alloc]init];
            formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
            formatter.formatOptions = NSISO8601DateFormatWithFractionalSeconds | NSISO8601DateFormatWithInternetDateTime;
            dateOfBirth = [formatter dateFromString:dateOfBirthString];
        }
        person.dateOfBirth = dateOfBirth;

        Login *login;
        NSDictionary *loginDictionary = [personDictionary valueForKey:@"login"];
        if (loginDictionary) {
            login = [[Login alloc]
                     initWithUsername:[loginDictionary valueForKey:@"username"]
                     password:[loginDictionary valueForKey:@"password"]
                     ];
        }
        person.login = login;

        FullName *fullName;
        NSDictionary *nameDictionary = [personDictionary valueForKey:@"name"];
        if (nameDictionary) {
            fullName = [[FullName alloc]
                        initWithFirstName:[nameDictionary valueForKey:@"first"]
                        lastName:[nameDictionary valueForKey:@"last"]
                        title:[nameDictionary valueForKey:@"title"]
                        ];
        }
        person.fullName = fullName;

        Gender gender = GenderUndefined;
        NSString* genderString = [personDictionary valueForKey:@"gender"];
        if (genderString) {
            if ([genderString isEqualToString:@"male"])
                gender = GenderMale;
            else if ([genderString isEqualToString:@"female"])
                gender = GenderFemale;
        }
        person.gender = gender;

        Picture *picture = [[Picture alloc]init];
        NSDictionary *pictureDictionary = [personDictionary valueForKey:@"picture"];
        if (pictureDictionary) {
            picture.largePictureURLString = [pictureDictionary valueForKey:@"large"];
            picture.mediumPictureURLString = [pictureDictionary valueForKey:@"medium"];
            picture.thumbnailPictureURLString = [pictureDictionary valueForKey:@"thumbnail"];
        }
        person.picture = picture;

        Location *location = [[Location alloc]init];
        NSDictionary *locationDictionary = [personDictionary valueForKey:@"location"];
        if (locationDictionary) {
            location.city = [locationDictionary valueForKey:@"city"];
            location.state = [locationDictionary valueForKey:@"state"];
            location.country = [locationDictionary valueForKey:@"country"];
            location.postcode = [locationDictionary valueForKey:@"postcode"];
            NSDictionary *streetDictionary = [locationDictionary valueForKey:@"street"];
            if (streetDictionary) {
                location.streetName = [streetDictionary valueForKey:@"name"];
                location.streetNumber = [streetDictionary valueForKey:@"number"];
            }
            NSDictionary *timezoneDictionary = [locationDictionary valueForKey:@"timezone"];
            if (timezoneDictionary) {
                location.timezoneDescription = [timezoneDictionary valueForKey:@"description"];
            }

            CLLocationCoordinate2D coordinates = kCLLocationCoordinate2DInvalid;
            NSDictionary *coordinatesDictionary = [locationDictionary valueForKey:@"coordinates"];
            if (coordinatesDictionary) {
                NSString *latitudeString = [coordinatesDictionary valueForKey:@"latitude"];
                NSString *longitudeString = [coordinatesDictionary valueForKey:@"longitude"];
                if (latitudeString && longitudeString) {
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    NSNumber *latitudeNumber = [formatter numberFromString:latitudeString];
                    NSNumber *longitudeNumber = [formatter numberFromString:longitudeString];
                    if (latitudeNumber && longitudeString) {
                        CLLocationDegrees latitude = [latitudeNumber doubleValue];
                        CLLocationDegrees longitude = [longitudeNumber doubleValue];
                        CLLocationCoordinate2D newCoordinates = CLLocationCoordinate2DMake(latitude, longitude);
                        if (CLLocationCoordinate2DIsValid(newCoordinates)) {
                            coordinates = newCoordinates;
                        }
                    }
                }
            }
            location.coordinates = coordinates;
        }
        person.location = location;

        [arrayOfPeople addObject:person];
    }
    return arrayOfPeople;
}

@end
