//
//  JSONParser.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkError.h"
#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface JSONParser : NSObject

- (NSArray<Person*>* _Nonnull)getPeopleFromJSONArray:(NSArray* _Nonnull)jsonArray;

@end

NS_ASSUME_NONNULL_END
