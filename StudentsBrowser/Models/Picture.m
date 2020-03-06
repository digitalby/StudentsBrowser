//
//  Picture.m
//  StudentsBrowser
//
//  Created by Digital on 06/03/2020.
//  Copyright © 2020 digitalby. All rights reserved.
//

#import "Picture.h"

@implementation Picture

- (NSString *)description
{
    return [NSString stringWithFormat:@"{\r    large: %@\r    medium: %@\r    thumbnail: %@\r}", self.largePictureURLString, self.mediumPictureURLString, self.thumbnailPictureURLString];
}

@end
