//
//  Location.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Location : NSObject

@property(nonatomic) CLLocationCoordinate2D coordinates;
@property(nonatomic) NSString * _Nullable city;
@property(nonatomic) NSString * _Nullable state;
@property(nonatomic) NSString * _Nullable country;
@property(nonatomic) NSString * _Nullable postcode;
@property(nonatomic) NSString * _Nullable streetName;
@property(nonatomic) NSString * _Nullable streetNumber;
@property(nonatomic) NSString * _Nullable timezoneDescription;

- (NSString* _Nonnull) description;

@end
