//
//  FullName.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FullName : NSObject

@property(nonatomic) NSString* firstName;
@property(nonatomic) NSString* lastName;
@property(nonatomic) NSString* title;

- (instancetype) initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName title:(NSString*)title;
- (NSString*) makeFirstAndLastName;
- (NSString*) makeTitleAndLastName;
- (NSString*) makeFullName;

- (NSString*) description;

@end

NS_ASSUME_NONNULL_END
