//
//  Person.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Gender.h"
#import "FullName.h"
#import "Login.h"
#import "Picture.h"
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property(nonatomic) NSString * _Nullable cellPhoneNumber;
@property(nonatomic) NSString * _Nullable phoneNumber;
@property(nonatomic) NSDate * _Nullable dateOfBirth;
@property(nonatomic, readonly, getter=age) NSUInteger age;
@property(nonatomic) NSString * _Nullable email;
@property(nonatomic) Gender * _Nullable gender;
@property(nonatomic) FullName * _Nullable fullName;
@property(nonatomic) NSString * _Nullable nationality;
@property(nonatomic) Login * _Nullable login;
@property(nonatomic) Picture * _Nullable picture;
@property(nonatomic) Location * _Nullable location;

@end

NS_ASSUME_NONNULL_END
