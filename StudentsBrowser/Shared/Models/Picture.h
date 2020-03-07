//
//  Picture.h
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Picture : NSObject

@property(nonatomic) NSString* largePictureURLString;
@property(nonatomic) NSString* mediumPictureURLString;
@property(nonatomic) NSString* thumbnailPictureURLString;

- (NSString*) description;

@end
